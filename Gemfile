# frozen_string_literal: true

source 'https://rubygems.org'
ruby file: '.ruby-version'

gem 'activesupport', require: 'active_support/all'
gem 'faraday-retry'
gem 'haml'
gem 'octokit'
gem 'omniauth-github'
gem 'propshaft'
gem 'puma'
gem 'rake'
gem 'sinatra', require: 'sinatra/base'
gem 'tilt'

group :production do
  gem 'thruster'
end

group :development do
  gem 'haml_lint', require: false
  gem 'irb'
  gem 'kamal', require: false
  gem 'listen'
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

group :test do
  gem 'faker'
  gem 'rack-test', require: 'rack/test'
  gem 'rspec'
  gem 'rspec-html-matchers'
  gem 'simplecov'
end
