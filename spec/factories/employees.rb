# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence :name do |n|
    "person#{n}"
  end
end
FactoryGirl.define do
  factory :employee do
    first_name { generate(:name) }
    last_name  {Faker::Name.last_name}
    phone {Faker::PhoneNumber.phone_number}
    employee_class {Employee.part_time}
    seniority "1234"
    trait :part_time do
      employee_class {Employee.part_time}
    end
    trait :full_time do
      employee_class {Employee.full_time}
    end
    trait :casual do
      employee_class {Employee.casual}
    end
  end
end
