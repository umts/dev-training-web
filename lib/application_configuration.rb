# frozen_string_literal: true

module ApplicationConfiguration
  def self.load!
    config = File.join(__dir__, '..', 'config', 'application.yml')
    Figaro.adapter = Figaro::Application
    Figaro.application = Figaro::Application.new(
      path: config,
      environment: ENV['RACK_ENV'] || 'development'
    )
    Figaro.load
  end
end
