class AddShiftTypeToShifts < ActiveRecord::Migration
  def change
    add_reference :shifts, :shift_type, index: true
  end
end
