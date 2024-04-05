# frozen_string_literal: true

require "rails_helper"

RSpec.describe WeatherService do
  describe "#current_temp_for" do
    context "when caching is off" do
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

    context "when caching is on" do
      subject { described_class.new(options) }

      let(:options) do
        {
          temp_scale: "Celsius",
          use_caching: true
        }
      end
      let(:fake_data) do
        {
          "temp_c" => 21.0,
          "temp_f" => 69.8
        }
      end

      before do
        allow(subject).to receive(:current).once.and_return(fake_data)
        subject.current_temp_for("Madrid")
      end

      it "using_cache should be false first time" do
        expect(subject.using_cache).to be_falsy
      end

      it "getting Madrid again should use cached value" do
        subject.current_temp_for("Madrid")
        expect(subject.using_cache).to be_truthy
      end
    end
  end

  describe "self.current_temp_for" do
    it "calls #current_temp_for on an instance" do
      expect_any_instance_of(described_class).to receive(:current_temp_for)
      described_class.current_temp_for("London")
    end
  end
end
