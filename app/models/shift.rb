class Shift < ActiveRecord::Base
  belongs_to :facility
  belongs_to :employees_role
  belongs_to :shift_type
  has_many   :employee_shifts
  has_many   :scheduled_shifts
  has_many   :call_out_shifts

  serialize :schedule_store, Hash
  delegate :name, to: :shift_type, prefix: true, allow_nil: true
  delegate :name, to: :facility, prefix: true, allow_nil: true
  delegate :role_abbreviation, :role_name, to: :employees_role, prefix: true, allow_nil: true

  accepts_nested_attributes_for :scheduled_shifts

  default_scope -> {order(:start_date, :start_hour, :start_minute)}
  scope :current, ->(date = Date.today) {where("end_date >= ? OR end_date is null", date)}
  scope :vacant, -> {where("employee_shifts.employee_id IS NULL").joins(:employee_shifts).group("shifts.facility_id","employee_shifts.id","shifts.id").includes(:employee_shifts)}

  def schedule_store=(new_schedule)
    write_attribute(:schedule_store, new_schedule == 'null' ? nil : RecurringSelect.dirty_hash_to_rule(new_schedule).to_hash)
  end

  def schedule(start_at = nil)
    return nil if schedule_store.blank?
    the_schedule = IceCube::Schedule.new(start_at || start_date || Date.today)
    the_schedule.add_recurrence_rule(RecurringSelect.dirty_hash_to_rule(schedule_store))
    the_schedule
  end

  def employee_shift
    scheduled_shifts.first || scheduled_shifts.build
  end

  def employee=(new_employee)
    employee_shift.employee = new_employee
  end

  def occurrences(this_start_date = nil, this_end_date = nil)
    this_start_date ||= start_date
    this_end_date ||= end_date
    this_start_date = [this_start_date, start_date].max
    this_end_date = [this_end_date, end_date].min
    return [ShiftOccurrence.new(this_start_date, self)] if schedule_store.blank?
    schedule(this_start_date).occurrences(this_end_date).map {|date| ShiftOccurrence.new(date, self)}
  end

  def start_time
    "#{start_hour.to_s.rjust(2, '0')}:#{start_minute.to_s.rjust(2, '0')}"
  end

  def start_at
    Time.now.change(hour: start_hour, min: start_minute)
  end

  def time_range
    "#{start_time} - #{end_time}"
  end

  def end_at
    return if shift_type.nil?
    @end_at ||= start_at + duration.hours
  end

  def duration
    shift_type.duration
  end

  def end_time
    "#{end_at.hour.to_s.rjust(2, '0')}:#{end_at.min.to_s.rjust(2, '0')}"
  end

end


