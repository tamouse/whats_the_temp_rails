# frozen_string_literal: true

# Persistence class for weather readings.
class Reading < ApplicationRecord; end

# NOTE: as there is no logic in this persistence class, there's nothing to test here,
#   I chose to not write specs for the Reading model as the code should be well
#   tested in the library.
