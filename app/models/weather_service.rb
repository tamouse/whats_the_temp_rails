# frozen_string_literal: true

# The WeatherService object wraps the WeatherAPI library to provide easy access
#   to the data, leaving the technicalities of retrieval to the library class
class WeatherService
  include ActiveModel::Model

  CELSIUS_SCALE = "Celsius"
  FAHRENHEIT_SCALE = "Fahrenheit"
  CACHE_TIMEOUT = 30.minutes

  attr_reader :temp_scale,       # Temperature scale to use, "Celsius" or "Fahrenheit"
              :use_caching,      # Flag to determine if we should cache or not
              :using_cache,      # Flag to tell if the value came from cache or hot
              :cache_timeout,    # How long to set the cache timeout
              :address,          # The address to use in the weather API query
              :temperature       # The current temperature

  validates :address, presence: true
  validates :temp_scale, presence: true, inclusion: { in: [CELSIUS_SCALE, FAHRENHEIT_SCALE] }

  def self.current_temp_for(address, options = {})
    new(options).current_temp_for(address)
  end

  def initialize(options = {})
    @options = options
    @temp_scale = options.fetch(:temp_scale, FAHRENHEIT_SCALE)
    @use_caching = options.fetch(:use_caching, false)
    @cache_timeout = options.fetch(:cache_timeout, CACHE_TIMEOUT)
  end

  # @param [String] address: The string to pass to query the service
  # @return [WeatherService] the current temperature
  def current_temp_for(address)
    @address = address
    if valid?
      if use_caching
        cached_fetch
      else
        temp_fetch
      end
    else
      @temperature = nil
    end
    self
  rescue KeyError => e
    errors.add(:base, e.message)
    self
  rescue WeatherAPI::Error => e
    errors.add(:api, e.message)
    self
  end

  def success?
    @temperature.present? && errors.emopty?
  end
  alias success success?

  private

  def cached_fetch
    @using_cache = true
    @temperature =
      Rails.cache.fetch(cache_key, expires_in: cache_timeout) do
        temp_fetch
      end
  end

  def temp_fetch
    @using_cache = false
    @temperature =
      if temp_scale == FAHRENHEIT_SCALE
        current(address).fetch("temp_f")
      elsif temp_scale == CELSIUS_SCALE
        current(address).fetch("temp_c")
      end
  end

  def cache_key
    "weather_service/#{address}/#{temp_scale}"
  end

  def current(address)
    client.current(address:).fetch("current")
  end

  def client
    @client ||= WeatherAPI.new
  end
end
