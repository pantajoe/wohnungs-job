FactoryBot.define do
  factory :sentry_error do
    day "2017-09-21"
    number_of_events 1
    repo_name "MyString"
  end
end
