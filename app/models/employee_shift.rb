class EmployeeShift < ActiveRecord::Base
  belongs_to :shift, touch: true
  has_one :facility, through: :shift
  has_one :employees_role, through: :shift
  belongs_to :employee
  has_many :employee_call_out_lists, foreign_key: :call_out_shift_id
  belongs_to :shift_replacement_reason

  delegate :employees_role, :time_of_day, :time_range, :schedule, to: :shift, prefix: false, allow_nil: false
  delegate :abreviation, to: :shift_replacement_reason, prefix: true, allow_nil: true
  #delegate :name, to: :employee, prefix: true, allow_nil: true

  scope :between, ->(start_date, end_date) {where("start_date <= ? and end_date >=?", end_date, start_date)}
  scope :on_date, ->(date) {between(date, date)}

  def employee_name
    employee.try(:name) || "Vacant"
  end

  def occurrences
    shift.occurrences(start_date, end_date)
  end

  def length
    occurrences.length
  end

  def occurrences_between(this_start_date, this_end_date)
    shift.occurrences([start_date, this_start_date].max, [this_end_date, end_date].min)
  end

  def days_of_week
    occurrences.map(&:wday).uniq.sort
  end

  def availabilities
    Availability.for_facility_on_days_for_role(facility, time_of_day, days_of_week, employees_role).distinct
  end

  def eligible_employees
    availabilities.map(&:employee)
  end

  def date_range
    "#{start_date} to #{end_date}"
  end

end
