# frozen_string_literal: true

class WeathersController < ApplicationController
  def index
    @reading = Reading.new
  end

  def show
    @reading = Reading.find(show_params[:id])
  end

  def create
    ws = WeatherService.current_temp_for(
      create_params[:address],
      { temp_scale: create_params[:temp_scale], use_caching: true }
    )

    reading = Reading.create({
                               address: ws.address,
                               temperature: ws.temperature,
                               temp_scale: ws.temp_scale,
                               service_errors: ws.errors,
                               used_cache: ws.using_cache,
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