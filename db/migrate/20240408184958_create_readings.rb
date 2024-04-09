# frozen_string_literal: true

# Migration to create the Reading model tabke
class CreateReadings < ActiveRecord::Migration[7.1]
  def change
    create_table :readings do |t|
      t.string  :address # The address entered by the user
      t.string  :temperature # tejpurature returned by the API, or nil
      t.string  :temp_scale, default: "Fahrenheit" # Either Fahrenheit or Celsius
      t.json    :service_errors, default: {} # Hash version of the errors object returned from the service.
      t.boolean :used_cache, null: false, default: false # A flag the indicates whether the return value was
      # pulled from Rails cache or if the service made a call
      t.string  :request_ip # The IP of the REMOTE_HOST from the request object

      t.timestamps
    end
  end
end
