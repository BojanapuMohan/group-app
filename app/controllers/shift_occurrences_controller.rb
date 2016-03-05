class ShiftOccurrencesController < ApplicationController
  def show
    @facility = Facility.find(params[:facility_id])
    shift = @facility.shifts.find(params[:shift_id])
    @shift_occurrence = ShiftOccurrence.new(params[:date], shift)
  end
end
