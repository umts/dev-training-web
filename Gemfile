# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read(File.expand_path('.ruby-version', __dir__)).strip

gem 'figaro'
gem 'haml'
gem 'octokit'
gem 'omniauth-github'
gem 'puma'
gem 'rake'
gem 'sassc'
gem 'sinatra', require: 'sinatra/base'
gem 'sprockets'
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
  gem 'capistrano', '~> 3.17', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-pending', require: false
  gem 'capistrano-rails', require: false
  gem 'ed25519', require: false
  gem 'haml_lint', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
end

group :development, :test do
  gem 'pry-byebug'
end
