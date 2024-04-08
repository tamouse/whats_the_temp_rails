# frozen_string_literal: true

# Default class all other ActiveRecord classes inherit from
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
