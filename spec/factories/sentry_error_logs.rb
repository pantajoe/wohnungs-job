FactoryBot.define do
  factory :sentry_error_log do
    timestamp 1
    errors 1
    repo_name "MyString"
    project nil
  end
end
