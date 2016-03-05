class MasterEmployeeReport < Dossier::Report


  def sql
    "SELECT first_name,last_name,
  COUNT(employee_id) AS called,
  SUM(CASE WHEN employee_call_out_results_view.result IN (#{EmployeeCallOutResult.declined_results.map {|result| "'" + result.result + "'"}.join(',')}) THEN 1 ELSE 0 END ) AS declined,
  SUM(CASE WHEN employee_call_out_results_view.result IN (#{EmployeeCallOutResult.no_answer_results.map {|result| "'" + result.result + "'"}.join(',')}) THEN 1 ELSE 0 END ) AS no_answer,
  SUM(CASE WHEN employee_call_out_results_view.result IN (#{EmployeeCallOutResult.accepted_results.map {|result| "'" + result.result + "'"}.join(',')}) THEN 1 ELSE 0 END ) AS accepted
   FROM employee_call_out_results_view
   WHERE employee_call_out_results_view.called_on
   BETWEEN '#{start_date}' AND '#{end_date}'
    GROUP BY employee_id,first_name,last_name"
  end

  def start_date
    options.fetch(:start_date, (Date.today - 30).to_s(:db))
  end

  def end_date
    options.fetch(:end_date, Date.today.to_s(:db))
  end

end
