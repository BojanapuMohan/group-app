class CreateEmployeeShiftReplacements < ActiveRecord::Migration
  def up
    file = File.open(Rails.root + "db/employee_shift_replacements_view.sql")
    execute file.read
  end

  def down
    execute "DROP VIEW IF EXISTS employee_shift_replacements"
  end
end
