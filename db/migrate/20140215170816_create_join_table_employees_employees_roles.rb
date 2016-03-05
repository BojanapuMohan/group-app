class CreateJoinTableEmployeesEmployeesRoles < ActiveRecord::Migration
  def change
    create_join_table :employees, :employees_roles do |t|
      t.index [:employee_id, :employees_role_id], name: 'index_on_employee_id_and_employees_role_id'
      t.index [:employees_role_id, :employee_id], name: 'index_on_employees_role_id_and_employee_id'
    end
  end
end
