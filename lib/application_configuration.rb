# frozen_string_literal: true

##
# helper module for loading Figaro configuration in the environment in a non-
# Rails application.
module ApplicationConfiguration
  ##
  # Read the `config/application.yml` file and load it into `ENV`
  def self.load!
    config = File.join(__dir__, '..', 'config', 'application.yml')
    Figaro.adapter = Figaro::Application
    Figaro.application = Figaro::Application.new(
      path: config,
      environment: ENV['APP_ENV'] || 'development'
    )
    Figaro.load
  end
end
