class RenameDatabaseColumn < ActiveRecord::Migration
  def change
  	change_table :employees do |t|
      t.rename :firstname, :first_name
      t.rename :lastname, :last_name
      t.rename :eclass, :employee_class
    end
  end
end
