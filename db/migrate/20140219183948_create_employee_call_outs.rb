class CreateEmployeeCallOuts < ActiveRecord::Migration
  def change
    create_table :employee_call_outs do |t|
      t.belongs_to :employee_call_out_list, index: true
      t.belongs_to :employee, index: true
      t.boolean :overtime
      t.boolean :rejected
      t.string :rule

      t.timestamps
    end
  end
end
