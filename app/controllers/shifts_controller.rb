class ShiftsController < ApplicationController
  before_action :set_facility

  def index
    @shifts = @facility.shifts.current
  end

  def new
    @shift = Shift.new
  end

  def edit
    @shift = Shift.find(params[:id])
  end

  def create
    @shift = ShiftManager.new_shift_for_facility(@facility, shift_params)
    if @shift.save
      redirect_to facility_shifts_path(@facility)
    else
      render :new
    end
  end

  def update
    @shift = Shift.find(params[:id])
    if ShiftManager.update_shift(@shift, shift_params)
      redirect_to facility_shifts_path(@facility)
    else
      render :new
    end
  end

  private
  def set_facility
    @facility = Facility.find(params[:facility_id])
  end

  def shift_params
    params.require(:shift).permit!
  end

end
