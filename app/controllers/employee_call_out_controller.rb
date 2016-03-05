class EmployeeCallOutController < ApplicationController

  def update
    @employee_call_out = EmployeeCallOut.find(params[:id]).decorate
    @employee_call_out.update_call_out(employee_call_out_params)
    if @employee_call_out.accepted_by_employee?
      @employee = @employee_call_out.employee
      @call_out_shift = @employee_call_out.call_out_shift
      @call_out_shift.employee = @employee_call_out.employee
    end
  end

  def duplicate
    @initial_call_out = EmployeeCallOut.find(params[:id])
    @employee_call_out = @initial_call_out.dup.decorate
  end

  private

  def employee_call_out_params
    params.require(:employee_call_out).permit!
  end
end
