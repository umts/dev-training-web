# frozen_string_literal: true

require 'bundler'
Bundler.require(:default, :test)

SimpleCov.start do
  load_profile 'test_frameworks'
  track_files 'lib/**/*.rb'
end

$LOAD_PATH.unshift File.join(__dir__, '..', 'lib')

Dir.glob(File.join(__dir__, 'support/**/*.rb')).sort.each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.filter_run_when_matching :focus
  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!

  config.warnings = true

  config.default_formatter = 'doc' if config.files_to_run.one?

  config.order = :random
  Kernel.srand config.seed
end
