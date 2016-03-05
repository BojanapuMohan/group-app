class RemoveEmpIdFromAvailabilities < ActiveRecord::Migration
  def change
    remove_column :availabilities, :emp_id, :integer
  end
end
