# frozen_string_literal: true

# The WeatherService object wraps the WeatherAPI library to provide easy access
#   to the data, leaving the technicalities of retrieval to the library class
class WeatherService
  include ActiveModel::Model

  CELSIUS_SCALE = "Celsius"
  FAHRENHEIT_SCALE = "Fahrenheit"

  attr_reader :temp_scale, :temperature

  validates :temp_scale, presence: true, inclusion: { in: [CELSIUS_SCALE, FAHRENHEIT_SCALE] }
  def initialize(options = {})
    @options = options
    @temp_scale = options.fetch(:temp_scale, FAHRENHEIT_SCALE)
  end

  # @param [String] address: The string to pass to query the service
  # @return [Boolean] the current temperature
  def current_temp_for(address)
    return false unless valid?

    @temperature =
      if temp_scale == FAHRENHEIT_SCALE
        current(address).fetch("temp_f")
      elsif temp_scale == CELSIUS_SCALE
        current(address).fetch("temp_c")
      end

    true
  rescue KeyError => e
    errors.add(:base, e.message)
    false
  end

  private

  def current(address)
    client.current(address:).fetch("current")
  end

  def client
    @client ||= WeatherAPI.new
  end
end
