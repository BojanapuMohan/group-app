# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :employee_call_out do
    overtime false
    rejected false
    factory :employee_call_out_with_employee do
      employee
    end
  end
end
