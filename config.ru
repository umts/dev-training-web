# frozen_string_literal: true

$LOAD_PATH.unshift File.join(__dir__, 'lib')

require 'bundler'
env = ENV['RACK_ENV']
Bundler.require(:default, env)

require 'dev_training_application'

map '/assets' do
  sprockets = Sprockets::Environment.new
  sprockets.append_path 'assets/stylesheets'
  sprockets.append_path 'assets/javascripts'
  sprockets.append_path 'assets/images'
  sprockets.append_path 'node_modules'
  run sprockets
end

map '/' do
  run DevTrainingApplication
end
