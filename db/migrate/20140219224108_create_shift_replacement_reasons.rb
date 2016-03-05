class CreateShiftReplacementReasons < ActiveRecord::Migration
  def change
    create_table :shift_replacement_reasons do |t|
      t.string :reason
      t.string :abreviation

      t.timestamps
    end
  end
end
