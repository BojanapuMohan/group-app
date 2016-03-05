class CallOutShiftsController < ApplicationController

  before_action :set_facility

  def create
    @call_out_shift = CallOutShift.create(call_out_shift_params)
    @shift = @call_out_shift.shift
    if params[:create_call_list]
      @employee_call_out_list = EmployeeCallOutList.create_for_call_out_shift(@call_out_shift, current_user)
      redirect_to facility_shift_occurrence_path(@facility, @shift, @call_out_shift.start_date)
    else
    redirect_to facility_schedule_path(@facility, start_date: @call_out_shift.start_date)
    end
  end

  def update
    @call_out_shift = CallOutShift.find(params[:id])
    @call_out_shift.update_attributes(call_out_shift_params)
    redirect_to facility_schedule_path(@facility, start_date: @call_out_shift.start_date)
  end

  private

  def call_out_shift_params
    params.require(:call_out_shift).permit!
  end

end
