class CreateEmployeeCallOutLists < ActiveRecord::Migration
  def change
    create_table :employee_call_out_lists do |t|
      t.belongs_to :call_out_shift
      t.belongs_to :user

      t.timestamps
    end
  end
end
