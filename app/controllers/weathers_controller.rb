# frozen_string_literal: true

# Controller handling requests for a tepm reading at an address
class WeathersController < ApplicationController
  # GET weathers
  def index
    @reading = Reading.new
  end

  # GET weater/:id
  def show
    @reading = Reading.find(show_params[:id])
  end

  # POST weathers
  def create
    ws = WeatherService.current_weather(
      create_params[:address],
      { temp_scale: create_params[:temp_scale], use_caching: true }
    )

    reading = Reading.create({
                               address: ws.address,
                               temperature: ws.temperature,
                               temp_scale: ws.temp_scale,
                               service_errors: ws.errors,
                               used_cache: ws.success? ? ws.using_cache : false,
                               request_ip: request.remote_host
                             })
    redirect_to action: :show, id: reading.id
  end

  private

  def create_params
    params.require(:reading).permit(:address, :temp_scale)
  end

  def show_params
    params.permit(:id)
  end
end
