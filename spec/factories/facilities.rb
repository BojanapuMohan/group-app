# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :facility do
    name "MyString"
    trait :shared_duty do
      has_shared_duty_shifts true
    end
  end
end
