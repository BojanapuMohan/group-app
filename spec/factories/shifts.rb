# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shift do
    shift_type
    start_date {Time.now.at_beginning_of_week.to_date}
    end_date {start_date + 365}
    start_hour 9
    start_minute 0
    time_of_day {DayOfWeekAvailability.times_of_day.first}
    ignore do
      dates [1,2,3,4,5]
      employee
    end
    trait :occuring_daily do
      schedule_store "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{},\"rule_type\":\"IceCube::DailyRule\"}"
    end
    trait :occuring_monday do
      schedule_store "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day\":[1]},\"rule_type\":\"IceCube::WeeklyRule\"}"
    end
    trait :occuring_tuesday do
      schedule_store "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day\":[2]},\"rule_type\":\"IceCube::WeeklyRule\"}"
    end
    trait :occuring_monday_tuesday do
      schedule_store "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day\":[1,2]},\"rule_type\":\"IceCube::WeeklyRule\"}"
    end
    trait :occuring_sunday_monday do
      schedule_store "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day\":[0,1]},\"rule_type\":\"IceCube::WeeklyRule\"}"
    end
    trait :occuring_staurday_sunday do
      schedule_store "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day\":[6,0]},\"rule_type\":\"IceCube::WeeklyRule\"}"
    end
    trait :occuring_monday_to_friday do
      schedule_store "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day\":[1,2,3,4,5]},\"rule_type\":\"IceCube::WeeklyRule\"}"
    end
    trait :occuring_monday_to_saturday do
      schedule_store "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day\":[1,2,3,4,5,6]},\"rule_type\":\"IceCube::WeeklyRule\"}"
    end
    trait :occuring_monday_wednesday_friday do
      schedule_store "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day\":[1,3,5]},\"rule_type\":\"IceCube::WeeklyRule\"}"
    end
    trait :occuring_thursday_saturday_sunday do
      schedule_store "{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day\":[4,6,0]},\"rule_type\":\"IceCube::WeeklyRule\"}"
    end
    trait :with_facility_and_role do
      facility
      employees_role
    end
    trait :current do
      start_date {Date.today - 7}
      end_date {Date.today + 7}
    end
    trait :general do
      shift_type {build(:shift_type, :general)}
    end
    trait :on_day_of_month do
      schedule_store {"{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day_of_month\":#{dates}},\"rule_type\":\"IceCube::MonthlyRule\"}"}
    end
    after(:create) do |shift, evaluator|
      create_list(:employee_shift, 1, shift: shift, employee: evaluator.employee, start_date: shift.start_date, end_date: shift.end_date) if evaluator.employee
    end
  end
end
