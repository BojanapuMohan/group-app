class AddEnabledToFacilities < ActiveRecord::Migration
  def change
    add_column :facilities, :enabled, :boolean, :default => true
  end
end
