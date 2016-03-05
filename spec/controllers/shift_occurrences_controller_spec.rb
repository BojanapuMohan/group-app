require 'spec_helper'

describe ShiftOccurrencesController do

  before :each do
    sign_in_admin
  end

  describe "GET 'show'" do
    let(:shift) {build_stubbed(:shift)}
    let(:facility) {build_stubbed(:facility)}
    before :each do
      Facility.stub(:find) {facility}
      facility.stub_chain(:shifts, :find) {shift}
    end
    it "returns http success" do
      get 'show', facility_id: 2, shift_id: 5, date: '2014-01-01'
      response.should be_success
    end
  end

end
