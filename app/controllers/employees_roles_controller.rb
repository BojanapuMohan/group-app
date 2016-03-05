class EmployeesRolesController < ApplicationController
  load_and_authorize_resource :except =>[:create]

  # GET /employees_roles
  # GET /employees_roles.json
  def index
    @employees_role = EmployeesRole.new()
  end


  # POST /employees_roles
  # POST /employees_roles.json
  def create
    @employees_role = EmployeesRole.create(employees_role_params)
    redirect_to employees_roles_path
  end

  # DELETE /employees_roles/1
  # DELETE /employees_roles/1.json
  def destroy
    @employees_role.disable!
    redirect_to employees_roles_path, :alert => "Employees_Roles disabled."
  end

  def enable
    @employees_role.enable!
    redirect_to employees_roles_path, :notice => "Employees_Roles is enabled."
  end

  def disable
    destroy
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def employees_role_params
      params.require(:employees_role).permit!
    end
end
