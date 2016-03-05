require 'time_range'
class ShiftOccurrence
  include Comparable

  delegate :shift_replacement_reason_abreviation, :date_range, to: :employee_shift, allow_nil: true, prefix: true
  delegate :employee_shifts, :facility, :facility_name, :employees_role, :employees_role_role_name, :start_time, :end_time, :start_minute, :start_hour, to: :shift, allow_nil: false, prefix: true
  delegate :time_range, to: :shift, prefix: true, allow_nil: false
  #delegate :name, to: :employee, allow_nil: true, prefix: true

  attr_accessor :date, :shift

  def initialize(time_or_date, shift)
    @date = time_or_date.to_date
    @shift = shift
  end

  def <=>(other)
    #return nil unless other.shift == self.shift
    self.date_time <=> other.date_time
  end

  def to_s
    date
  end

  def date_time
    @date_time ||= Time.new(date.year, date.month, date.day, shift_start_hour, shift_start_minute)
  end

  def end_time
    date_time + duration.hours
  end

  def end_date
    end_time.to_date
  end

  def time_range
    @time_range ||= TimeRange.new(date_time, end_time)
  end

  def wday
    date_time.wday
  end

  def id
    shift.id
  end

  def duration
    shift.duration
  end

  def employee_shift
    @employee_shift ||= employee_shifts.last
  end

  def employee_shifts
    @employee_shifts ||= shift_employee_shifts.on_date(date)
  end

  def employee_name
    employee.try(:name) || "Vacant"
  end

  def td_class
    employee ? 'scheduled' : 'vacant'
  end

  def employee
    @employee ||= employee_shift.try(:employee)
  end

  def employee_call_out_lists
    @employee_call_out_lists ||= employee_shifts.map(&:employee_call_out_lists).flatten
  end

  def regularly_scheduled_shift?(this_employee)
    employee_shifts_for_employee(this_employee).first.is_a?(ScheduledShift)
  end

  def casual_shift?(this_employee)
    !regularly_scheduled_shift?(this_employee)
  end

  def break_since(other_occurrence)
    return 0 if other_occurrence.end_time > date_time
    (date_time - other_occurrence.end_time) / 60 / 60
  end

  private

  def employee_shifts_for_employee(this_employee)
    employee_shifts.select {|employee_shift| employee_shift.employee == this_employee}
  end


end

NullShiftOccurrence = Naught.build do |config|
  config.mimic ShiftOccurrence

  def td_class
    'not_scheduled'
  end

  def employee_name
    "Not Scheduled"
  end

end
