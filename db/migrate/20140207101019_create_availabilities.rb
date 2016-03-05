class CreateAvailabilities < ActiveRecord::Migration
  def change
    create_table :availabilities do |t|
      t.integer :emp_id
      t.string :morning
      t.string :evening
      t.string :night

      t.timestamps
    end
  end
end
