# frozen_string_literal: true

source 'https://rubygems.org'
ruby file: '.ruby-version'

gem 'faraday-retry'
gem 'figaro'
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
  gem 'capistrano', '~> 3.18', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-pending', require: false
  gem 'capistrano-rails', require: false
  gem 'ed25519', require: false
  gem 'haml_lint', require: false
  gem 'irb'
  gem 'rubocop', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
end

group :development, :test do
  gem 'debug'
end
