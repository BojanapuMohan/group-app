class AddFieldsToAvailability < ActiveRecord::Migration
  def change
    add_column :availabilities, :facilities_ids, :text, array: true, default: []
    add_column :availabilities, :day_of_week_availabilities_ids, :text, array: true, default: []
    add_column :availabilities, :employees_roles_ids, :text, array: true, default: []
  end
end
