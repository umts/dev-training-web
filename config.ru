# frozen_string_literal: true

$LOAD_PATH.unshift File.join(__dir__, 'lib')

require 'bundler'
env = ENV['APP_ENV'] = ENV['RACK_ENV']
Bundler.require(:default, env)

require 'application_configuration'
ApplicationConfiguration.load!

require 'application_assets'
require 'dev_training_application'


map('/assets') { run ApplicationAssets.new } unless env == 'production'
map('/') { run DevTrainingApplication }
