require 'factory_bot'
require 'faker'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.filter_run_excluding :skip_travis if ENV['TRAVIS']
  config.filter_run_excluding :slow
  config.run_all_when_everything_filtered = true

  config.before(:suite) do
    FactoryBot.reload
  end

  config.example_status_persistence_file_path = 'spec/examples.txt'
  config.disable_monkey_patching!
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.profile_examples = 10

  config.before(:each) do
    ENV['DISABLE_PRY'] = nil
  end

  config.order = :random
  Kernel.srand config.seed
end
