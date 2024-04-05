require 'spec_helper'
require File.expand_path("../../../lib/weather_api", __FILE__)

RSpec.describe WeatherAPI do
  let(:address) { "55118" }
  let(:client) { WeatherAPI.new(api_key: api_key) }

  describe "#create_url" do
    let(:api_key) { "abc123" }
    it "returns the expected URL" do
      actual = client.send(:create_url, **{q: address, path: "/current.json"})
      expected = "http://api.weatherapi.com/v1/current.json?key=abc123&q=55118&aqi=no"
      expect(actual.to_s).to eq(expected)
    end
  end
end
