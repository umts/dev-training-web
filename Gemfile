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
gem 'sinatra', require: false
gem 'sprockets'
gem 'tilt'

group :test do
  gem 'rspec', require: false
  gem 'simplecov', require: false
end

group :development do
  gem 'capistrano', '~> 3.17', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', require: false
  gem 'haml-lint', require: false
  gem 'rubocop', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
end

group :development, :test do
  gem 'pry-byebug'
end
