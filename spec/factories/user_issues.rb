# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_issue do
    user nil
    issue nil
  end
end
