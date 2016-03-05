class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
    	t.integer :user_id
    	t.text :note
    	t.belongs_to :employee, index: true
      t.timestamps
    end
  end
end
