class CreateEmployeeCallOutResults < ActiveRecord::Migration
  def change
    create_table :employee_call_out_results do |t|
      t.string :result

      t.timestamps
    end
  end
end
