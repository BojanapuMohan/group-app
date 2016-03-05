class AddEnabledToEmployeesRoles < ActiveRecord::Migration
  def change
    add_column :employees_roles, :enabled, :boolean, :default => true
  end
end
