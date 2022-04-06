# frozen_string_literal: true

$LOAD_PATH.unshift File.join(__dir__, 'lib')

require 'bundler'
env = ENV['APP_ENV'] || 'development'
Bundler.require(:default, env)

require 'application_configuration'
ApplicationConfiguration.load!

require 'application_assets'
require 'rake/sprocketstask'

desc 'Generate a cryptographically secure secret key (this is typically used to ' \
     'generate a secret for cookie sessions).'
task :secret do
  require 'securerandom'
  puts SecureRandom.hex(64)
end

Rake::SprocketsTask.new do |sprockets|
  sprockets.environment = ApplicationAssets.new
  sprockets.output = File.join(__dir__, "public#{ApplicationAssets::ASSET_ROOT}")
  sprockets.assets = %w[manifest.js]
end

# Aliases for capistrano-rails to invoke
# rubocop:disable Rake/Desc
namespace :assets do
  task(:precompile) { Rake::Task['assets'].invoke }
  task(:clean) { Rake::Task['clean_assets'].invoke }
  task(:clobber) { Rake::Task['clobber_assets'].invoke }
end
# rubocop:enable Rake/Desc

unless env == 'production'
  require 'haml_lint/rake_task'
  require 'rdoc/task'
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'

  RDoc::Task.new do |rdoc|
    rdoc.markup = 'markdown'
    rdoc.rdoc_files.include('README.md', 'lib/**/*.rb')
    rdoc.main = 'README.md'
    rdoc.rdoc_dir = 'docs'
  end

  RuboCop::RakeTask.new do |rubocop|
    next unless ENV['CI']

    rubocop.options = [['--fail-level', 'W'], '--display-only-fail-level-offenses', '--fail-fast']
    rubocop.formatters = ['simple']
  end

  HamlLint::RakeTask.new do |hl|
    next unless ENV['CI']

    hl.fail_level = 'error'
    hl.quiet = false
  end

  RSpec::Core::RakeTask.new(:spec) do |rspec|
    next unless ENV['CI']

    rspec.rspec_opts = ['--format progress', '--fail-fast', '--no-profile']
  end

  desc 'Run all tests and linters.'
  task :default do
    %w[spec rubocop haml_lint].each { |t| Rake::Task[t].invoke }
  end
end
