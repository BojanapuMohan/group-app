class AddHasSharedDutyShiftsToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :has_shared_duty_shifts, :boolean, default: false
  end
end
