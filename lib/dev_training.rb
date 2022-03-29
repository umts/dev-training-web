# frozen_string_literal: true

require 'dev_training/training'

##
# Contains the classes that represent the various GitHub resources for a
# developer's training program.
module DevTraining
  ##
  # Convenience module method. Calling `DevTraining.new` returns a new
  # DevTraining::Training object.
  def self.new(...)
    DevTraining::Training.new(...)
  end
end
