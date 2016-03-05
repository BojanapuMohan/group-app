class FacilitiesController < ApplicationController
  load_and_authorize_resource :except =>[:create]
  before_action :set_facility, only: [:show, :edit, :update, :destroy]

  # GET /facilities
  # GET /facilities.json
  def index
  end

  # GET /facilities/new
  def new
  end

  # POST /facilities
  # POST /facilities.json
  def create
    @facility = Facility.new(facility_params)
    if @facility.save
      redirect_to facilities_path, notice: 'Facility was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /facilities/1
  # PATCH/PUT /facilities/1.json
  def update
    respond_to do |format|
      if @facility.update(facility_params)
        format.html { redirect_to facilities_path, notice: 'Facility was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @facility.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /facilities/1
  # DELETE /facilities/1.json

  def destroy
    @facility.disable!
    redirect_to facilities_path, :alert => "Facility is disabled."
  end

  def enable
    @facility.enable!
    redirect_to facilities_path, :notice => "Facility is enabled."
  end

  def disable
    destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_facility
    @facility = Facility.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def facility_params
    params.require(:facility).permit(:name)
  end
end
