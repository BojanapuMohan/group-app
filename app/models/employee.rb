class Employee < ActiveRecord::Base
  include CanEnable

  has_one  :availability
  has_many :notes
  has_many :employee_shifts
  has_many :vacations
  has_many :employee_shift_replacements

  default_scope ->{order('last_name, first_name')}



def self.import(file)
  CSV.foreach(file.path, :headers => true) do |row|
      # Finding employee by sin number,Update if exist
      # Create new if not exist
      employee = find_by_sin(row["sin"]) || new
      employee.attributes = row.to_hash
      employee.save!
  end
end



  def self.part_time
    "Regular part time"
  end

  def self.casual
    "Casual"
  end

  def self.full_time
    "Regular full time"
  end

  def self.employee_classes
    [full_time, part_time, casual]
  end

  def part_time?
    employee_class == self.class.part_time
  end

  def casual?
    employee_class == self.class.casual
  end

  def full_time?
    employee_class == self.class.full_time
  end

  def availability
    super || build_availability
  end

  def name
    [first_name, last_name].join(" ")
  end

  def call_on_vacation?
    availability.call_on_vacation?
  end

  def shifts_scheduled_between(this_start_date, this_end_date)
    employee_shifts.between(this_start_date, this_end_date).map {|employee_shift| employee_shift.occurrences_between(this_start_date, this_end_date)}.flatten
  end

  def dates_scheduled_between(start_date, this_end_date)
    shifts_scheduled_between(start_date, this_end_date).map(&:date)
  end

  def scheduled_between?(this_start_date, this_end_date)
    shifts_scheduled_between(this_start_date, this_end_date).present?
  end

  def shifts_worked_between(this_start_date, this_end_date)
    @shifts_worked_between ||= {}
    @shifts_worked_between["#{this_start_date.to_s(:db)}-#{this_end_date.to_s(:db)}"] ||= shifts_scheduled_between(this_start_date, this_end_date).select {|occurrence| occurrence.employee == self}
  end

  def hours_worked_between(this_start_date, this_end_date)
    shifts_worked_between(this_start_date, this_end_date).sum(&:duration)
  end

  def dates_worked_between(this_start_date, this_end_date)
    shifts_worked_between(this_start_date, this_end_date).map(&:date)
  end

  def regular_shifts_worked_between(this_start_date, this_end_date)
    shifts_worked_between(this_start_date, this_end_date).select {|occurrence| occurrence.regularly_scheduled_shift?(self) }
  end

  def regular_shifts_scheduled_between(this_start_date, this_end_date)
    shifts_scheduled_between(this_start_date, this_end_date).select {|occurrence| occurrence.regularly_scheduled_shift?(self) }
  end

  def on_vacation?(this_start_date, this_end_date = nil)
    vacations.between(this_start_date, this_end_date || this_start_date).count > 0
  end

end
