class CreateAvailabilitiesFacilities < ActiveRecord::Migration
  def change
    create_table :availabilities_facilities do |t|
    	t.integer :availability_id
      t.integer :facility_id
    end
  end
end
