class ShiftManager
  def self.new_shift_for_facility(facility, shift_params)
    shift = facility.shifts.build(shift_params)
    shift.employee_shift.assign_attributes(start_date: shift.start_date, end_date: shift.end_date)
    shift
  end

  def self.update_shift(shift, shift_params)
    shift.update_attributes(shift_params)
    shift.employee_shifts.each do |employee_shift|
      employee_shift.start_date = shift.start_date if employee_shift.start_date.blank? || shift.start_date > employee_shift.start_date
      employee_shift.end_date = shift.end_date if employee_shift.end_date.blank? || shift.end_date < employee_shift.end_date
      employee_shift.save
    end
    shift.valid?
  end
end
