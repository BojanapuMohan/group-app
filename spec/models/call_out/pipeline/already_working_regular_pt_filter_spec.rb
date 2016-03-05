require "spec_helper"

describe CallOut::Pipeline::AlreadyWorkingRegularPtFilter do

  it_behaves_like 'a filter' do
    context "preconditions" do
      before :each do
        call_out_shift.stub(:length) {5}
        employee.stub(:part_time?) {true}
        subject.stub(:rejected?) {true}
      end
      it "should be true" do
        expect(subject).to have_pre_conditions_met
      end
      it "should be false if the employee is not part time" do
        employee.stub(:part_time?) {false}
        expect(subject).to_not have_pre_conditions_met
      end
      it "should be false if the call out shift is less than 5 days" do
        call_out_shift.stub(:length) {4}
        expect(subject).to_not have_pre_conditions_met
      end
      it "should be false if the callout has not been rejected" do
        subject.stub(:rejected?) {false}
        expect(subject).to_not have_pre_conditions_met
      end
    end
    it "should reject an already working employee" do
      regular_shift = ShiftOccurrence.new(Date.tomorrow, shift)
      regular_shift.stub(:regularly_scheduled_shift?) {true}
      employee.stub(:shifts_scheduled_between) {[regular_shift]}
      employee.stub(:dates_worked_between) {[Date.today, Date.tomorrow]}
      subject.stub(:shift_dates) {[Date.tomorrow]}
      subject.should_receive(:accept!)
      subject.call
    end
    describe :the_filter, async: true do
      let(:current_user) {build_stubbed(:user)}
      let!(:facility) {create(:facility)}
      let!(:employee_role) {create(:employees_role)}
      let!(:employee1) {create(:employee, :part_time)}
      let!(:employee2) {create(:employee, :full_time)}
      let!(:monday_tuesday) {create(:shift, :occuring_monday_tuesday, employee: employee1, facility: facility, employees_role: employee_role)}
      let!(:monday_to_friday) {create(:shift, :occuring_monday_to_friday, employee: employee2, facility: facility, employees_role: employee_role)}
      let!(:casual_shift) {create(:casual_shift, start_date: Time.now.at_beginning_of_week.to_date + 8, end_date: Time.now.at_beginning_of_week.to_date + 18, shift: monday_to_friday)}
      before :each do
        make_fully_available(employee1)
      end
      it "should include part time employees working any of the days" do
        expect( Availability.for_facility_on_days_for_role(facility, "Morning", [1,2,3,4,5], employee_role).distinct).to include(employee1.availability)
        expect( casual_shift.availabilities).to include(employee1.availability)
        expect(casual_shift.eligible_employees).to include(employee1)
        call_out_list = EmployeeCallOutList.create_for_call_out_shift(casual_shift, current_user)
        expect(call_out_list.reload.eligible_employees).to include(employee1)
        expect(call_out_list.eligible_employees).to_not include(employee2)
      end

    end
  end

end
