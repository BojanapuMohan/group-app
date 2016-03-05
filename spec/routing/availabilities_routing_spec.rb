require "spec_helper"

describe AvailabilitiesController do
  describe :routing do
    it "routes to employee availability" do
      get("/employees/1/availability").should route_to("availabilities#edit", :employee_id => "1")
    end
    it "updates the availability" do
      post("/employees/1/availability").should route_to("availabilities#update", :employee_id => "1")
    end
  end
end
