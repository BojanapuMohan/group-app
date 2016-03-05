class AddFacilitiesUsersJoinTable < ActiveRecord::Migration
  def change
  	create_table :facilities_users do |t|
  		t.integer :user_id
  		t.integer :facility_id
    end
  end
end
