class CreateVacations < ActiveRecord::Migration
  def up
    execute <<-SQL
    CREATE OR REPLACE VIEW vacations AS
SELECT
  employee_shifts.start_date AS start_date,
  employee_shifts.end_date AS end_date,
  replaced_shifts.employee_id AS employee_id,
  employee_shifts.shift_id AS shift_id
FROM
  employee_shifts employee_shifts, employee_shifts replaced_shifts
WHERE
  employee_shifts.replaced_shift_id = replaced_shifts.id AND
  employee_shifts.shift_replacement_reason_id = (
SELECT
      shift_replacement_reasons.id
    FROM
      shift_replacement_reasons
    WHERE
      shift_replacement_reasons.reason = 'Vacation'
 )
    SQL
  end

  def down
    execute "DROP VIEW IF EXISTS vacations"
  end
end
