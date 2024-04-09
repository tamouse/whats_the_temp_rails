# frozen_string_literal: true

# WeatherAPI - client for the weatherapi.com api
class WeatherAPI
  # Keep the Api Key in environment variables for privacy needs.
  API_KEY = ENV.fetch("WEATHER_API_KEY", nil)
  # This is better as an environment variable, too, not for privacy, but if the URL
  # needs to change for a specific environment.
  BASE_URL = ENV.fetch("WEATHER_BASE_URL", "http://api.weatherapi.com/v1")

  attr_accessor :api_key, :base_url

  class Error < StandardError; end
  class MissingAPIKey < Error; end
  class MissingBaseUrl < Error; end

  def initialize(api_key: nil, base_url: nil)
    # Optional arguments are helpful with testing
    @api_key = api_key || API_KEY
    @base_url = base_url || BASE_URL
  end

  # There are jore options on the request, which could be passed in here.
  # The address is the one bit that's required.
  def current(address:)
    # Set guards to the app doesn't run away if misconfigured.
    raise MissingAPIKey, "API_KEY is not set" if api_key.nil?
    raise MissingBaseUrl, "BASE_URL is not set" if base_url.nil?

    # For this example, only the current conditions are being retrieved.
    url = create_url(query: address, path: "/current.json")
    response = get(url)

    # Raise the error from this object so it can be handled by the caller
    raise WeatherAPI::Error, "Problem with the WeatherAPI: response code: #{response.code}" if response.code.to_i >= 400

    JSON.parse(response.body)
  end

  # NOTE: If there were other types of information being retrieved from the service,
  #   they would have their own method and options In that case, it makes sense to
  #   make the request call and handle errors and responses in private methods
  #   that all of the main methods would call.

  private

  # The form of the URI is "#{base_url}/current.json?key=#{api_key}&q=#{address}&aqi=no"
  # Constructing it via URI model is helpful to make sure nothing gets left out.
  def create_url(query:, path:)
    url = URI(base_url)
    url.path = url.path + path
    url.query = URI.encode_www_form(key: api_key, q: query, aqi: "no")
    url
  end

  # Makes it easier if someone wants to replace Net::HTTP with some other library
  def get(url)
    Net::HTTP.get_response(url)
  end
end
