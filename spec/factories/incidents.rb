FactoryBot.define do
  factory :incident do
    time_from "2017-09-11 16:23:21"
    time_to "2017-09-11 16:23:21"
    what_happened "MyText"
    which_server "MyString"
    realized_error "MyText"
    solution "MyText"
    impacts "MyText"
    future_approach "MyText"
    project nil
  end
end
