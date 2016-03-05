class CallOutShift < EmployeeShift
  belongs_to :replaced_shift, class_name: "EmployeeShift"

  attr_accessor :add_on_shift

  before_update :create_fill_in_shift

  def self.build_from_shift_occurence(shift_occurrence)
    new(shift: shift_occurrence.shift, replaced_shift: shift_occurrence.employee_shift, start_date: shift_occurrence.date, end_date: shift_occurrence.date)
  end

  def replaced_employee
    replaced_shift.employee
  end

  def regular_shift?
    false
  end

  def casual_shift?
    true
  end


  private

  def create_fill_in_shift
    return unless end_date_changed? && end_date_was > end_date
    new_call_out_shift = self.dup
    new_call_out_shift.end_date = end_date_was
    new_call_out_shift.start_date = end_date + 1
    new_call_out_shift.employee = nil
    new_call_out_shift.save!
    self.add_on_shift = new_call_out_shift
  end
end
