require 'spec_helper'

describe SchedulesController do

  before :each do
    sign_in_admin
    Facility.stub(:find) {build_stubbed(:facility)}
  end

  describe "GET 'show'" do
    it "returns http success" do
      get 'show', facility_id: 5
      response.should be_success
    end
  end

end
