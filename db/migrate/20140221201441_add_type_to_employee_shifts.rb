class AddTypeToEmployeeShifts < ActiveRecord::Migration
  def change
    add_column :employee_shifts, :type, :string
  end
end
