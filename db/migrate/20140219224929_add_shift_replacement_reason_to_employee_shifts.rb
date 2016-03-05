class AddShiftReplacementReasonToEmployeeShifts < ActiveRecord::Migration
  def change
    add_reference :employee_shifts, :shift_replacement_reason, index: true
  end
end
