# frozen_string_literal: true

require_relative 'config/environment'

require 'asset_assembly'

namespace :assets do
  desc 'Precompile application assets'
  task precompile: :'css:build' do
    AssetAssembly.new.processor.process
  end

  desc 'Delete precompiled assets'
  task :clobber do
    rm_rf AssetAssembly.new.config.output_path
  end
end

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

namespace :css do
  desc 'Install CSS dependencies'
  task :install do
    system('npm install')
  end

  desc 'Build CSS'
  task build: :install do
    system('npm run build:css')
  end
end

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

  desc 'Prepare for testing'
  task 'test:prepare' => 'css:build'

  RSpec::Core::RakeTask.new(:spec) do |rspec|
    next unless ENV['CI']

    rspec.rspec_opts = ['--format progress', '--fail-fast', '--no-profile']
  end

  desc 'Run all tests and linters.'
  task :default do
    %w[spec rubocop haml_lint].each { |t| Rake::Task[t].invoke }
  end
end
