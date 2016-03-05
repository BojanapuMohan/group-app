class AddJoinTableForDowa < ActiveRecord::Migration
  def change
    create_join_table :availability, :day_of_week_availability do |t|
      t.index :availability_id
      t.index :day_of_week_availability_id, name: 'index_availability_dow_availability_on_dow_availability_id'
    end
  end
end
