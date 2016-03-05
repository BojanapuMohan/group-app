class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.date :start_date, index: true
      t.date :end_date, index: true
      t.belongs_to :facility, index: true
      t.belongs_to :employees_role, index: true
      t.text :schedule_store
      t.integer :start_hour
      t.integer :start_minute

      t.timestamps
    end
  end
end
