CREATE OR REPLACE VIEW employee_shift_replacements AS

SELECT
  new_shift.created_at AS created_at,
  new_shift.start_date AS start_date,
  new_shift.end_date AS end_date,
  initial_shift.employee_id AS employee_id,
  new_shift.shift_id AS shift_id,
  new_shift.shift_replacement_reason_id AS shift_replacement_reason_id
FROM
  employee_shifts initial_shift, employee_shifts new_shift
WHERE
  new_shift.replaced_shift_id = initial_shift.id
