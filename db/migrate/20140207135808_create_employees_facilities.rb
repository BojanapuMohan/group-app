class CreateEmployeesFacilities < ActiveRecord::Migration
  def change
    create_table :employees_facilities do |t|
    	t.integer :employee_id
        t.integer :facility_id
    end
  end
end
