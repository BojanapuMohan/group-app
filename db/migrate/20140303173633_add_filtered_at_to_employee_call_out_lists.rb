class AddFilteredAtToEmployeeCallOutLists < ActiveRecord::Migration
  def change
    add_column :employee_call_out_lists, :filtered_at, :datetime
  end
end
