class AddDefaultsToOvertimeAndRejected < ActiveRecord::Migration
  def change
    change_column :employee_call_outs, :rejected, :boolean, default: false
    change_column :employee_call_outs, :overtime, :boolean, default: false
  end
end
