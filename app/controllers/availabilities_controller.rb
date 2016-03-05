class AvailabilitiesController < ApplicationController
  before_action :set_availability

  def edit
  end

  def update
    @availability.assign_attributes(availability_params)
    if @availability.save
      redirect_to employees_path
    else
      render :edit
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_availability
    @employee = Employee.find(params[:employee_id])
    @availability = @employee.availability
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def availability_params
    params.require(:availability).permit!
  end
end
