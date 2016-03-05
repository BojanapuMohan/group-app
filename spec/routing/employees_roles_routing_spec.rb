require "spec_helper"

describe EmployeesRolesController do
  describe "routing" do

    it "routes to #index" do
      get("/employees_roles").should route_to("employees_roles#index")
    end

    it "routes to #create" do
      post("/employees_roles").should route_to("employees_roles#create")
    end

    it "routes to #destroy" do
      delete("/employees_roles/1").should route_to("employees_roles#destroy", :id => "1")
    end

  end
end
