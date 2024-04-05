# frozen_string_literal: true

require "spec_helper"
require File.expand_path("../../lib/weather_api", __dir__)

RSpec.describe WeatherAPI do
  let(:client) { described_class.new(api_key:) }

  describe "#create_url" do
    let(:api_key) { "abc123" }
    let(:address) { "Anywhere" }

    it "returns the expected URL" do
      actual = client.send(:create_url, query: address, path: "/current.json")
      expected = "http://api.weatherapi.com/v1/current.json?key=abc123&q=Anywhere&aqi=no"
      expect(actual.to_s).to eq(expected)
    end

    context "when the address contains spaces" do
      let(:address) { "Some Bogus Stuff" }

      it "escapes the spaces in the query" do
        actual = client.send(:create_url, query: address, path: "/current.json")
        expected = "http://api.weatherapi.com/v1/current.json?key=abc123&q=Some+Bogus+Stuff&aqi=no"
        expect(actual.to_s).to eq(expected)
      end
    end
  end

  describe "#current" do
    let(:api_key) { nil }

    context "when address is a zip code" do
      let(:address) { "55118" }

      it "retrieves the weather information for the address" do
        VCR.use_cassette "current_#{address}" do
          @actual = client.current(address:)
        end
        expect(@actual).not_to be_nil
        expect(@actual).to be_a(Hash)
        expect(@actual.keys.sort).to eq(%w[location current].sort)
        expect(@actual.dig("location", "name")).to eq("Saint Paul")
        expect(@actual.dig("location", "region")).to eq("Minnesota")
        expect(@actual.dig("current").keys).to include(*%w[temp_f temp_c last_updated])
      end
    end

    context "when address is a city" do
      let(:address) { "Saint Paul" }

      it "retrieves the weather information for the address" do
        VCR.use_cassette "current_#{address}" do
          @actual = client.current(address:)
        end
        expect(@actual).not_to be_nil
        expect(@actual).to be_a(Hash)
        expect(@actual.keys.sort).to eq(%w[location current].sort)
        expect(@actual.dig("location", "name")).to eq("Saint Paul")
        expect(@actual.dig("location", "region")).to eq("Minnesota")
        expect(@actual.dig("current").keys).to include(*%w[temp_f temp_c last_updated])
      end
    end

    context "when address is a IP address" do
      let(:address) { "24.118.131.105" }

      it "retrieves the weather information for the address" do
        VCR.use_cassette "current_#{address}" do
          @actual = client.current(address:)
        end
        expect(@actual).not_to be_nil
        expect(@actual).to be_a(Hash)
        expect(@actual.keys.sort).to eq(%w[location current].sort)
        expect(@actual.dig("location", "name")).to eq("Eagan")
        expect(@actual.dig("location", "region")).to eq("Minnesota")
        expect(@actual.dig("current").keys).to include(*%w[temp_f temp_c last_updated])
      end
    end

    context "when address is auto:ip looking" do
      let(:address) { "auto:ip" }

      it "retrieves the weather information for the address" do
        VCR.use_cassette "current_#{address}" do
          @actual = client.current(address:)
        end
        expect(@actual).not_to be_nil
        expect(@actual).to be_a(Hash)
        expect(@actual.keys.sort).to eq(%w[location current].sort)
        expect(@actual.dig("location", "name")).to eq("Eagan")
        expect(@actual.dig("location", "region")).to eq("Minnesota")
        expect(@actual.dig("current").keys).to include(*%w[temp_f temp_c last_updated])
      end
    end

    context "when address is unrecognizable" do
      let(:address) { SecureRandom.base64 }

      it "retrieves the weather information for the address" do
        VCR.use_cassette "current_#{address}" do
          expect { client.current(address:) }.to raise_error(WeatherAPI::Error, "Problem with the WeatherAPI: response code: 400")
        end
      end
    end
  end
end
