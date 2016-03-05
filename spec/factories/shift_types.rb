# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shift_type do
    name "MyString"
    duration 60*8
    trait :general do
      duration 60*8
    end
  end

end
