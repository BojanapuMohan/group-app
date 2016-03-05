class CreateJoinTableAvailabilitiesEmployeesRoles < ActiveRecord::Migration
  def change
    create_join_table :availabilities, :employees_roles do |t|
      t.index [:availability_id, :employees_role_id], name: 'index_on_availability_id_and_employees_role_id'
      t.index [:employees_role_id, :availability_id], name: 'index_on_employees_role_id_and_availability_id'
    end
  end
end
