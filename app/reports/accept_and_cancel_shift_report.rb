class AcceptAndCancelShiftReport < Dossier::Report


  def sql
    "SELECT employees.first_name || ' ' || employees.last_name AS Employee_Name ,COUNT(*)
     FROM employee_shift_replacements
     INNER JOIN employees ON employees.id = employee_shift_replacements.employee_id
     WHERE employee_shift_replacements.created_at
      BETWEEN '#{start_date}' AND '#{end_date}'
     AND shift_replacement_reason_id = #{(ShiftReplacementReason.self_cancelled).id}
     GROUP BY employees.first_name, employees.last_name"

  end

  def start_date
    options.fetch(:start_date, (Date.today - 30).to_s(:db))
  end

  def end_date
    options.fetch(:end_date, Date.today.to_s(:db))
  end

end
