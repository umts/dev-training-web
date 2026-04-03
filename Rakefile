# frozen_string_literal: true

require_relative 'config/environment'

require 'application_configuration'
ApplicationConfiguration.load!

require 'application_assets'
require 'rake/sprocketstask'

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

namespace :credentials do
  desc 'Outputs the credentials stored in `ARGV[1]` (used by diff helper)'
  task :diff do
    credentials = ActiveSupport::EncryptedConfiguration.new(
      config_path: File.expand_path(ARGV[1], __dir__),
      key_path: CREDENTIALS.key_path,
      env_key: CREDENTIALS.env_key,
      raise_if_missing_key: false
    )
    begin
      puts credentials.read.presence || credentials.content_path.read
    rescue ActiveSupport::MessageEncryptor::InvalidMessage
      puts credentials.content_path.read
    end
  end

  desc 'Edit the credentials file using the system editor'
  task :edit do
    require 'rails/command/helpers/editor'
    include Rails::Command::Helpers::Editor

    using_system_editor { CREDENTIALS.change { |tempfile| system_editor(tempfile) } }
  end

  desc 'Show the credentials stored in the credentials file'
  task :show do
    puts CREDENTIALS.read.presence || 'No decryptable credentials found'
  end
end

unless ENV.fetch('RACK_ENV', 'development') == 'production'
  require 'fileutils'
  require 'haml_lint/rake_task'
  require 'rdoc/task'
  require 'rspec/core/rake_task'
  require 'rubocop/rake_task'

  RDoc::Task.new do |rdoc|
    rdoc.markup = 'markdown'
    rdoc.generator = 'aliki'
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
