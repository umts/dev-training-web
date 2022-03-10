# frozen_string_literal: true

require 'bundler'
$LOAD_PATH.unshift File.join(__dir__, 'lib')

env = ENV['RACK_ENV']
Bundler.require(:default, env)

require 'dev_training_application'
run DevTrainingApplication
