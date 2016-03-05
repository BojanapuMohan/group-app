class EmployeesController < ApplicationController
  load_and_authorize_resource :except =>[:create]
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  # GET /employees
  # GET /employees.json
  def index
    @employees = @employees = Employee.all
  end



def import
  Employee.import(params[:file])
  redirect_to employees_path, notice: "Products imported."
end



  def seniority
    @employees = Employee.all
  end
  
  def seniority_update
    @pemployees = params[:employees]
    @pemployees.each do |employee|
     emp=Employee.find(employee[0])
     emp.update_attribute(:seniority, employee[1])
     end
    redirect_to employees_path
  end

  # GET /employees/new
  def new
    @employee = Employee.new
  end

  # GET /employees/1/edit
  def edit
    @notes = (@employee.notes).order('created_at DESC')
  end

  def create_note
    @note = @employee.notes.build(note_params)
    if @note.save
      redirect_to :back
    end  
    
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to employees_url, notice: 'Employee was successfully created.' }
        format.json { render action: 'show', status: :created, location: @employee }
      else
        format.html { render action: 'new' }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to employees_url, notice: 'Employee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.disable!
    redirect_to employees_path, :alert => "Employee disabled."
  end

  def enable
    @employee.enable!
    redirect_to employees_path, :notice => "Employee is enabled."
  end

  def disable
    destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit!
    end

    def note_params
      params.require(:note).permit!
    end
end
