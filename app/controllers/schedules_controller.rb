class SchedulesController < ApplicationController
  def index
    @shifts = Shift.vacant.sort_by{|shift| [shift.facility_id, shift.start_at]}    
  end

  def show
    @facility = Facility.find(params[:facility_id])
    @start_date = Date.parse(params.fetch(:start_date) {Date.today.to_s(:db)}).beginning_of_week
    @end_date = @start_date.end_of_week
    @range = (@start_date..@end_date)
    @shifts = @facility.shifts.current(@start_date).sort_by{|shift| [shift.employees_role_id, shift.start_at]}
    @shift_occurrences = ShiftOccurrenceCollection.new(@shifts, @start_date, @end_date)
    respond_to do |format|
      format.js
      format.html
    end
  end
end
