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
      subject do
        actual = nil
        VCR.use_cassette "current_#{address}" do
          actual = client.current(address:)
        end
        actual
      end

      let(:address) { "55118" }

      it { is_expected.not_to be_nil }
      it { is_expected.to be_a(Hash) }

      it "has location and current keys" do
        expect(subject.keys.sort).to eq(%w[location current].sort)
      end

      it "name is Saint Paul" do
        expect(subject.dig("location", "name")).to eq("Saint Paul")
      end

      it "region is Minnesota" do
        expect(subject.dig("location", "region")).to eq("Minnesota")
      end

      it "current has temperature and last updated fields" do
        expect(subject["current"].keys).to include(*%w[temp_f temp_c last_updated])
      end
    end

    context "when address is a city" do
      subject do
        actual = nil
        VCR.use_cassette "current_#{address}" do
          actual = client.current(address:)
        end
        actual
      end

      let(:address) { "Saint Paul" }

      it { is_expected.not_to be_nil }
      it { is_expected.to be_a(Hash) }

      it "has location and current keys" do
        expect(subject.keys.sort).to eq(%w[location current].sort)
      end

      it "name is Saint Paul" do
        expect(subject.dig("location", "name")).to eq("Saint Paul")
      end

      it "region is Minnesota" do
        expect(subject.dig("location", "region")).to eq("Minnesota")
      end

      it "current has temperature and last updated fields" do
        expect(subject["current"].keys).to include(*%w[temp_f temp_c last_updated])
      end
    end

    context "when address is a IP address" do
      subject do
        actual = nil
        VCR.use_cassette "current_#{address}" do
          actual = client.current(address:)
        end
        actual
      end

      let(:address) { "24.118.131.105" }

      it { is_expected.not_to be_nil }
      it { is_expected.to be_a(Hash) }

      it "has location and current keys" do
        expect(subject.keys.sort).to eq(%w[location current].sort)
      end

      it "name is Eagan" do
        expect(subject.dig("location", "name")).to eq("Eagan")
      end

      it "region is Minnesota" do
        expect(subject.dig("location", "region")).to eq("Minnesota")
      end

      it "current has temperature and last updated fields" do
        expect(subject["current"].keys).to include(*%w[temp_f temp_c last_updated])
      end
    end

    context "when address is auto:ip looking" do
      subject do
        actual = nil
        VCR.use_cassette "current_#{address}" do
          actual = client.current(address:)
        end
        actual
      end

      let(:address) { "auto:ip" }

      it { is_expected.not_to be_nil }
      it { is_expected.to be_a(Hash) }

      it "has location and current keys" do
        expect(subject.keys.sort).to eq(%w[location current].sort)
      end

      it "name is Eagan" do
        expect(subject.dig("location", "name")).to eq("Eagan")
      end

      it "region is Minnesota" do
        expect(subject.dig("location", "region")).to eq("Minnesota")
      end

      it "current has temperature and last updated fields" do
        expect(subject["current"].keys).to include(*%w[temp_f temp_c last_updated])
      end
    end

    context "when address is unrecognizable" do
      subject do
        actual = nil
        VCR.use_cassette "current_#{address}" do
          actual = client.current(address:)
        end
        actual
      end

      let(:address) { "3blQ0KDw4Ah64CuPVpNLMw==" }

      it "retrieves the weather information for the address" do
        VCR.use_cassette "current_#{address}" do
          expect do
            client.current(address:)
          end.to raise_error(WeatherAPI::Error, "Problem with the WeatherAPI: response code: 400")
        end
      end
    end
  end
end
