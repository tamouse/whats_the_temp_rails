# frozen_string_literal: true

require "rails_helper"

RSpec.describe WeatherService do
  describe "#current_temp_for" do
    context "when temp_scale is Celsius" do
      let(:service) { described_class.new(temp_scale: "Celsius") }

      before do
        VCR.use_cassette "weather_service/current_temp_for/when_temp_scale_is_celsius" do
          # NOTE: Sadly, this could be brittle, if the VCR cassette changes and the conditions are different
          assert(service.current_temp_for("London"))
        end
      end

      it "returns the current temp in Celsius" do
        expect(service.temperature).to eq(13.0)
      end
    end

    context "when temp_scale is Fahrenheit" do
      let(:service) { described_class.new(temp_scale: "Fahrenheit") }

      before do
        VCR.use_cassette "weather_service/current_temp_for/when_temp_scale_is_fahrenheit" do
          # NOTE: Sadly, this could be brittle, if the VCR cassette changes and the conditions are different
          assert(service.current_temp_for("London"))
        end
      end

      it "returns the current temp in Fahrenheit" do
        expect(service.temperature).to eq(55.4)
      end
    end
  end
end
