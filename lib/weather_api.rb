# frozen_string_literal: true

# WeatherAPI - client for the weatherapi.com api
class WeatherAPI
  API_KEY = ENV.fetch("WEATHER_API_KEY", nil)
  BASE_URL = ENV.fetch("WEATHER_BASE_URL", "http://api.weatherapi.com/v1")

  attr_accessor :api_key, :base_url

  class Error < StandardError; end

  def initialize(api_key: nil, base_url: nil)
    @api_key = api_key || API_KEY
    @base_url = base_url || BASE_URL
  end

  def current(address:)
    url = create_url(query: address, path: "/current.json")
    response = Net::HTTP.get_response(url)
    raise WeatherAPI::Error, "Problem with the WeatherAPI: response code: #{response.code}" if response.code.to_i >= 400

    JSON.parse(response.body)
  end

  private

  def create_url(query:, path:)
    url = URI(base_url)
    old_path = url.path
    url.path = old_path + path
    url.query = URI.encode_www_form(key: api_key, q: query, aqi: "no")
    url
  end
end
