# frozen_string_literal: true

require "rails_helper"

RSpec.describe WeatherService do
  describe "#current_weather" do
    let(:temp_c) { 21.0 }
    let(:temp_f) { 69.8 }
    let(:fake_data) do
      {
        "temp_c" => temp_c,
        "temp_f" => temp_f
      }
    end

    before do
      allow(subject).to receive(:current).once.and_return(fake_data)
    end

    context "when caching is off" do
      context "when temp_scale is Celsius" do
        subject { described_class.new(temp_scale: "Celsius") }

        before do
          assert(subject.current_weather("London"))
        end

        it "returns the current temp in Celsius" do
          expect(subject.temperature).to eq(temp_c)
        end
      end

      context "when temp_scale is Fahrenheit" do
        subject { described_class.new(temp_scale: "Fahrenheit") }

        before do
          assert(subject.current_weather("London"))
        end

        it "returns the current temp in Fahrenheit" do
          expect(subject.temperature).to eq(temp_f)
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

      before do
        subject.current_weather("Madrid")
      end

      it "using_cache should be false first time" do
        expect(subject.using_cache).to be_falsy
      end

      it "getting Madrid again should use cached value" do
        subject.current_weather("Madrid")
        expect(subject.using_cache).to be_truthy
      end
    end
  end

  describe "self.current_weather" do
    it "calls #current_weather on an instance" do
      expect_any_instance_of(described_class).to receive(:current_weather)
      described_class.current_weather("London")
    end
  end
end
