require 'spec_helper'

describe CallOutListsController do
  let(:employee_call_out_list) {build_stubbed(:employee_call_out_list)}
  let(:call_out_shift) {build_stubbed(:employee_shift)}
  let(:facility) {build_stubbed(:facility)}
  before :each do
    Facility.stub(:find) {facility}
    EmployeeShift.stub(:find) {call_out_shift}
    sign_in_admin
  end
  describe :show do
    before :each do
      call_out_shift.stub_chain(:employee_call_out_lists, :find) {employee_call_out_list}
    end
    it "should render the table if it's filtered" do
      employee_call_out_list.stub(:filtered?) {true}
      get :show, facility_id: 1, call_out_shift_id: 1, id: 1, format: :js
      expect(response).to render_template("show")
    end
  end
end
