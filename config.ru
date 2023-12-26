# frozen_string_literal: true

$LOAD_PATH.unshift File.join(__dir__, 'lib')

require 'bundler'
env = ENV['APP_ENV'] = ENV.fetch('RACK_ENV', 'development')
Bundler.require(:default, env)

require 'application_configuration'
ApplicationConfiguration.load!

require 'application_assets'
require 'dev_training_application'

map(ApplicationAssets::ASSET_ROOT) { run ApplicationAssets.new } unless env == 'production'
map('/') { run DevTrainingApplication }
