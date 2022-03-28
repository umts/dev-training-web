# frozen_string_literal: true

$LOAD_PATH.unshift File.join(__dir__, 'lib')

require 'bundler'
env = ENV['APP_ENV'] || 'development'
Bundler.require(:default, env)

require 'application_configuration'
ApplicationConfiguration.load!

require 'application_assets'
require 'rake/sprocketstask'

desc <<~DESC.gsub(/\s+/, ' ')
  Generate a cryptographically secure secret key (this is typically used to
  generate a secret for cookie sessions).
DESC
task :secret do
  require 'securerandom'
  puts SecureRandom.hex(64)
end

Rake::SprocketsTask.new do |t|
  t.environment = ApplicationAssets.new
  t.output = File.join(__dir__, 'public/assets')
  t.assets = %w[manifest.js]
end
