class CreateDayOfWeekAvailabilities < ActiveRecord::Migration
  def change
    create_table :day_of_week_availabilities do |t|
      t.integer :day_of_week
      t.string :time_of_day

      t.timestamps
    end
  end
end
