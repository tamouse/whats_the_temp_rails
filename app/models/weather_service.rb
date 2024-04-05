class WeatherService
  include ActiveModel::Model

  CELSIUS_SCALE = "Celsius"
  FAHRENHEIT_SCALE = "Fahrenheit"

  attr_accessor :temp_scale

  validates :temp_scale, presence: true, inclusion: { in: [CELSIUS_SCALE, FAHRENHEIT_SCALE] }
  def initialize(options = {})
    @options = options
    self.temp_scale = options.fetch(:temp_scale, FAHRENHEIT_SCALE)
  end

  def current_temp_for(address)
    if valid?
      if temp_scale == FAHRENHEIT_SCALE
        current(address).temp_f
      elsif temp_scale == CELSIUS_SCALE
        current(address).temp_c
      end
    end
  end

  private

  def current(address)
    OpenStruct.new(client.current(address:).dig("current"))
  end

  def client
    @client ||= WeatherAPI.new
  end
end
