# Remind developers to install pre-commit
ENV['PRECOMMIT'] ||= 'true'
if ENV['PRECOMMIT'] == 'true'
  hook_file = "#{Rails.root}/.git/hooks/pre-commit"
  if !File.readable?(hook_file) || File.read(hook_file).blank?
    puts 'Please install pre-commit hooks by running'
    puts 'pre-commit install'
    exit 1
  end
end

# Load schema.rb if migrations are pending
ActiveRecord::Migration.maintain_test_schema!
