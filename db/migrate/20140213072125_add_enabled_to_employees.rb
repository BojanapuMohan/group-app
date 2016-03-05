class AddEnabledToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :enabled, :boolean, :default => true
  end
end
