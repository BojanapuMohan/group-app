class UpdateCallOutView < ActiveRecord::Migration
  def change
    file = File.open(Rails.root + "db/employee_call_out_results_view.sql")
    execute file.read
  end
end
