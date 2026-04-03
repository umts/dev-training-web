# frozen_string_literal: true

env = ENV.fetch('RACK_ENV', 'development')
$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'bundler/setup'
Bundler.require(:default, env)
Dotenv.load('.env', '.env.local', ".env.#{env}", ".env.#{env}.local") if defined?(Dotenv)
require_relative 'credentials'
