# frozen_string_literal: true

source 'https://rubygems.org'
ruby file: '.ruby-version'

gem 'activesupport', require: 'active_support/all'
gem 'faraday-retry'
gem 'haml'
gem 'octokit'
gem 'omniauth-github'
gem 'puma'
gem 'rake'
gem 'sinatra', require: 'sinatra/base'
gem 'sprockets'
gem 'sprockets-sass_embedded'
gem 'tilt'

group :test do
  gem 'faker'
  gem 'rack-test', require: 'rack/test'
  gem 'rspec'
  gem 'rspec-html-matchers'
  gem 'simplecov'
end

group :development do
  gem 'bcrypt_pbkdf', require: false
  gem 'ed25519', require: false
  gem 'haml_lint', require: false
  gem 'irb'
  gem 'railties', require: false
  gem 'rdoc', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
end

group :development, :test do
  gem 'debug'
  gem 'dotenv'
end
