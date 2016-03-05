class CreateEmployeeShifts < ActiveRecord::Migration
  def change
    create_table :employee_shifts do |t|
      t.date :start_date
      t.date :end_date
      t.belongs_to :shift, index: true
      t.belongs_to :employee, index: true

      t.timestamps
    end
  end
end
