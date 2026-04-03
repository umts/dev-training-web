# frozen_string_literal: true

require_relative 'config/environment'

require 'application_configuration'
ApplicationConfiguration.load!

require 'application_assets'
require 'dev_training_application'

map(ApplicationAssets::ASSET_ROOT) { run ApplicationAssets.new } if ENV.fetch('RACK_ENV', 'development') != 'production'
map('/') { run DevTrainingApplication }
