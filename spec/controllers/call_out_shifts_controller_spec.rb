require 'spec_helper'

describe CallOutShiftsController do
  describe :create do
    let(:facility) {build_stubbed(:facility)}
    let(:shift) {build_stubbed(:shift)}
    let(:params) { {facility_id: facility.id, call_out_shift: {replaced_shift_id: shift.id, start_date: Date.today.to_s(:db), end_date: Date.today.to_s(:db)}} }
    before :each do
      sign_in_admin
      Facility.stub(:find) {facility}
      Shift.stub(:find) {shift}
    end
    it "should create a CallOtShift" do
      expect{post :create, params}.to change{CallOutShift.count}.by(1)
    end
  end

end
