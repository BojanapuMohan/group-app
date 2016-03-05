class AddCalledAtToEmployeeCallOuts < ActiveRecord::Migration
  def change
    add_column :employee_call_outs, :called_at, :datetime
  end
end
