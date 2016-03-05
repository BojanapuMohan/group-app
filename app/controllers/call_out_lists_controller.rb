class CallOutListsController < ApplicationController
  before_action :set_facility
  before_action :set_call_out_shift

  def show
    @employee_call_out_list = @call_out_shift.employee_call_out_lists.find(params[:id])
  end

  def create
    @employee_call_out_list = EmployeeCallOutList.create_for_call_out_shift(@call_out_shift, current_user)
    redirect_to facility_shift_occurrence_path(@facility, @call_out_shift.shift, @call_out_shift.start_date)
  end

  private

  def set_call_out_shift
    @call_out_shift = EmployeeShift.find(params[:call_out_shift_id])
  end

end
