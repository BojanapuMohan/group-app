class EmployeeCallOutResultView < ActiveRecord::Base
  self.primary_key = :id
  self.table_name = :employee_call_out_results_view

  belongs_to :employee

  def read_only?
    true
  end
end
