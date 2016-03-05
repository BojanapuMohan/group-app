class AddTimeOfDayToShift < ActiveRecord::Migration
  def change
    add_column :shifts, :time_of_day, :string
  end
end
