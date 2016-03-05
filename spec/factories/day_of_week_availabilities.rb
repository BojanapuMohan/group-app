# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :day_of_week_availability do
    day_of_week 1
    time_of_day "MyString"
  end
end
