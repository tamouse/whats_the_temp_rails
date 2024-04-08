# frozen_string_literal: true

class CreateReadings < ActiveRecord::Migration[7.1]
  def change
    create_table :readings do |t|
      t.string  :address
      t.string  :temperature
      t.string  :temp_scale, default: "Fahrenheit"
      t.json    :service_errors, default: {}
      t.boolean :used_cache, null: false, default: false
      t.string  :request_ip

      t.timestamps
    end
  end
end
