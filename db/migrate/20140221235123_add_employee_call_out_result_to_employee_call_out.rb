class AddEmployeeCallOutResultToEmployeeCallOut < ActiveRecord::Migration
  def change
    add_reference :employee_call_outs, :employee_call_out_result, index: true
  end
end
