class CreateEmployeesRoles < ActiveRecord::Migration
  def change
    create_table :employees_roles do |t|
      t.string :role_name
      t.string :role_abbreviation

      t.timestamps
    end
  end
end
