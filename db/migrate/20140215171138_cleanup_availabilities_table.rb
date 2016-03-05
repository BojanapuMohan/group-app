class CleanupAvailabilitiesTable < ActiveRecord::Migration
  def change
    remove_column :availabilities, :morning
    remove_column :availabilities, :evening
    remove_column :availabilities, :night
    remove_column :availabilities, :facilities_ids
    remove_column :availabilities, :day_of_week_availabilities_ids
    remove_column :availabilities, :employees_roles_ids
  end
end
