require "spec_helper"

describe CallOut::Pipeline::DeclinedStraightTimeFilter do
  it_behaves_like "a filter" do
    describe :pre_conditions do
      before :each do
        call_out_shift.stub(:employee_call_out_lists) {[double, double]}
        employee_call_out.stub(:overtime?) {true}
      end
      it "should be false if there is not more than 1 call out list and the employee has been marked as having overtime" do
        call_out_shift.stub(:employee_call_out_lists) {[double]}
        expect(subject).to_not have_pre_conditions_met
      end
      it "should be false if the employee has not been marked as having overtime" do
        employee_call_out.stub(:overtime?) {false}
        expect(subject).to_not have_pre_conditions_met
      end
      it "should otherwise be true" do
        expect(subject).to have_pre_conditions_met
      end
    end
    describe :the_filter, async: true do
      let(:start_date) {Time.now.at_beginning_of_week.to_date}
      let(:end_date) {start_date + 7}
      let!(:facility) {create(:facility)}
      let!(:employee_role) {create(:employees_role)}

      let!(:employee1) {create(:employee, :part_time, first_name: "one")}
      let!(:monday_wednesday_friday) {create(:shift, :occuring_monday_wednesday_friday, :general, employee: employee1, facility: facility, employees_role: employee_role, start_hour: 9)}

      let!(:employee2) {create(:employee, :full_time, first_name: "two")}
      let!(:tuesday) {create(:shift, :occuring_tuesday, :general, employee: create(:employee), facility: facility, employees_role: employee_role, start_hour: 9)}
      let!(:casual_shift) {create(:casual_shift, employee: employee2, start_date: start_date, end_date: end_date, shift: tuesday, replaced_shift: tuesday.employee_shifts.first)}

      let!(:thursday_saturday_sunday) {create(:shift, :occuring_thursday_saturday_sunday, :general, employee: create(:employee), facility: facility, employees_role: employee_role, start_hour: 9)}
      let!(:blocking_casual_shift) {create(:casual_shift, employee: employee1, start_date: start_date, end_date: end_date, shift: tuesday, replaced_shift: thursday_saturday_sunday.employee_shifts.first)}

      let!(:second_casual_shift) {create(:casual_shift, start_date: start_date, end_date: end_date, shift: tuesday, replaced_shift: casual_shift)}

      let(:employee3) {create(:employee)}

      before :each do
        make_fully_available(employee1)
        make_fully_available(employee2)
        make_fully_available(employee3)
      end

      context "on the second try" do
        before :each do
          call_out_list = create(:employee_call_out_list, call_out_shift: casual_shift)
          call_out_list.employee_call_outs << EmployeeCallOut.new(employee: employee1, overtime: false, employee_call_out_result: EmployeeCallOutResult.declined_results.first)
        end

        it "should reject an employee for overtime if they have passed on the shift for regular time" do
          expect(second_casual_shift.eligible_employees).to include(employee1)
          call_out_list = EmployeeCallOutList.create_for_call_out_shift(second_casual_shift, current_user)
          expect(call_out_list).to have_at_least(1).employee_call_outs
          expect(call_out_list.reload.eligible_employees).to_not include(employee1)
        end
        it "shouldn't include the vacating employee" do
          call_out_list = EmployeeCallOutList.create_for_call_out_shift(casual_shift, current_user)
          expect(call_out_list.reload.eligible_employees).to_not include(employee2)
        end
        it "should include other employees" do
          call_out_list = EmployeeCallOutList.create_for_call_out_shift(casual_shift, current_user)
          expect(call_out_list.reload.eligible_employees).to include(employee3)
        end
      end


    end
  end
end
