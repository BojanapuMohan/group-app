class CreateCallOutView < ActiveRecord::Migration
  def up
    execute <<-SQL
    CREATE OR REPLACE VIEW employee_call_out_results_view AS
SELECT
    employee_call_outs.id AS id,
    employee_call_outs.employee_id AS employee_id,
    employees.first_name AS first_name,
    employees.last_name AS last_name,
    employee_call_outs.updated_at AS updated_at,
    employee_call_outs.called_at AS called_at,
    employee_call_out_results.result AS result
FROM
  employee_call_outs
    INNER JOIN employees ON (employees.id = employee_call_outs.employee_id)
    INNER JOIN employee_call_out_results ON (employee_call_out_results.id = employee_call_outs.employee_call_out_result_id)
ORDER BY last_name, first_name
    SQL
  end

  def down
    execute "DROP VIEW IF EXISTS employee_call_out_results_view"
  end

end
