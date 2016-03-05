class AddEmployeeIdToAvailability < ActiveRecord::Migration
  def change
    add_column :availabilities, :employee_id, :integer
  end
end
