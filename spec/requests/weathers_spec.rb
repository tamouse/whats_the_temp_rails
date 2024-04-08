# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Weathers" do
  describe "GET /index" do
    it "returns http success" do
      get weathers_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    let(:reading) do
      Reading.create(
        address: "Somewhere Hot",
        temperature: 40.0,
        temp_scale: "Celsius",
        service_errors: {},
        used_cache: false
      )
    end

    it "returns http success" do
      get weather_path(reading.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "redirects to show" do
      VCR.use_cassette "request/weathers/post_create/redrects_to_show" do
        post weathers_path, params: { reading: { address: "55118", temp_scale: "Fahrenheit" } }
        reading = Reading.order(updated_at: :asc).last
        expect(response).to redirect_to(weather_path(reading.id))
      end
    end
  end
end
