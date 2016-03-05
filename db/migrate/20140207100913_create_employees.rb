class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.string :firstname
      t.string :lastname
      t.string :phone
      t.string :eclass
      t.string :seniority

      t.timestamps
    end
  end
end
