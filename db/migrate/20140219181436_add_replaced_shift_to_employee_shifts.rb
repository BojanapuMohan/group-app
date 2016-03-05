class AddReplacedShiftToEmployeeShifts < ActiveRecord::Migration
  def change
    add_reference :employee_shifts, :replaced_shift, index: true
  end
end
