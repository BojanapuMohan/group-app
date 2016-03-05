require "spec_helper"

describe CallOut::Pipeline::AlreadyWorkingRegularPtOverTimeFilter do

  it_behaves_like 'a filter' do
    context "preconditions" do
      before :each do
      end
    end
    describe :the_filter, async: true do
      let(:current_user) {build_stubbed(:user)}
      let!(:facility) {create(:facility)}
      let!(:employee_role) {create(:employees_role)}
      let!(:employee1) {create(:employee, :part_time, first_name: "one")}
      let!(:employee2) {create(:employee, :part_time, first_name: "two")}
      let!(:employee3) {create(:employee, :full_time, first_name: "three")}
      let!(:monday) {create(:shift, :occuring_monday, :general, employee: employee1, facility: facility, employees_role: employee_role, start_hour: 9)}
      let!(:saturday_sunday) {create(:shift, :occuring_sunday_monday, :general, employee: employee2, facility: facility, employees_role: employee_role, start_hour: 9)}
      let!(:monday_to_friday) {create(:shift, :occuring_monday_to_friday, :general, employee: employee3, facility: facility, employees_role: employee_role, start_hour: 9)}
      let!(:casual_shift) {create(:casual_shift, start_date: Time.now.at_beginning_of_week.to_date + 21, end_date: Time.now.at_beginning_of_week.to_date + 35, shift: monday_to_friday, replaced_shift: monday_to_friday.employee_shifts.first)}
      before :each do
        make_fully_available(employee1)
        make_fully_available(employee2)
        make_fully_available(employee3)
      end
      it "should include an employee who does overlap and does note incurr overtime" do
        call_out_list = EmployeeCallOutList.create_for_call_out_shift(casual_shift, current_user)
        expect(call_out_list.eligible_employees).to include(employee1)
        expect(call_out_list.overtime_employees).to_not include(employee1)
      end
      it "should not include employees who do overlap and incurr overtime" do
        call_out_list = EmployeeCallOutList.create_for_call_out_shift(casual_shift, current_user)
        expect(call_out_list.eligible_employees).to_not include(employee2)
        expect(call_out_list.overtime_employees).to include(employee2)
      end
      it "shouldn't include the vacating employee" do
        call_out_list = EmployeeCallOutList.create_for_call_out_shift(casual_shift, current_user)
        expect(call_out_list.eligible_employees).to_not include(employee3)
      end
    end
  end
end
