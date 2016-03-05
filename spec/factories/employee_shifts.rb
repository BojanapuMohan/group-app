# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :employee_shift, class: ScheduledShift do
    start_date {Time.now.to_date}
    end_date { start_date + 14 }
    factory :call_out_shift, class: CallOutShift do
      end_date {start_date + 1}
    end
    factory :casual_shift, class: CallOutShift do
      end_date {start_date + 1}
    end
    trait :vacation do
      shift_replacement_reason {ShiftReplacementReason.vacation}
    end
  end
end
