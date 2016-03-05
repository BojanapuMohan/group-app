class AddPositionToEmployeeCallOuts < ActiveRecord::Migration
  def change
    add_column :employee_call_outs, :position, :integer
  end
end
