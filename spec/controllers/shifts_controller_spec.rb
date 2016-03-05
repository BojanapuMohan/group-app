require 'spec_helper'

describe ShiftsController do
  before :each do
    sign_in_admin
  end

  describe :index do

  end

  describe :create do
    let!(:facility) {create(:facility)}
    let(:params) {
      {
        "shift"=>{
          "employees_role_id"=>"14",
          "schedule_store"=>"{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day\":[1,3,5]},\"rule_type\":\"IceCube::WeeklyRule\"}",
          "start_date"=>"02/01/2014",
          "end_date"=>"02/28/2014",
          "start_hour"=>"7",
          "start_minute"=>"11",
          #"employee_id"=>"1",
          "time_of_day"=>"Evening"},
        "commit"=>"Create Shift",
        "facility_id"=> facility.id
      }
    }
    it "should set the schedule" do
      post :create, params
      shift = facility.shifts.first
      expect(shift.schedule).to be_a(IceCube::Schedule)
      expect(shift.time_of_day).to eql('Evening')
    end
  end


end
