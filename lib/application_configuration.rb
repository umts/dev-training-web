# frozen_string_literal: true

require 'figaro'

##
# helper module for loading Figaro configuration in the environment in a non-
# Rails application.
module ApplicationConfiguration
  def self.config_file # :nodoc:
    File.join(__dir__, '..', 'config', 'application.yml')
  end

  ##
  # Read the `config/application.yml` file and load it into `ENV`
  def self.load!
    Figaro.adapter = Figaro::Application
    Figaro.application = Figaro::Application.new(
      path: config_file,
      environment: ENV['APP_ENV'] || 'development'
    )
    Figaro.load
  end
end
