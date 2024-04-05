require 'rails_helper'

RSpec.describe WeatherService do
  describe "#current_temp_for" do
    context "when temp_scale is Celsius" do
      let(:service) { WeatherService.new(temp_scale: "Celsius") }

      it "returns the current temp in Celsius" do
        VCR.use_cassette "weather_service/current_temp_for/when_temp_scale_is_celsius" do
          expect(service.current_temp_for("Londond")).to eq(1.1)
        end
      end
    end
  end
end
