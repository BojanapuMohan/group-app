require "spec_helper"

describe CallOut::Pipeline::AlreadyWorkingBetterOptionFilter do

  it_behaves_like 'a filter' do
    let(:call_out_shift) {build_stubbed(:call_out_shift, shift: shift, start_date: Date.today + 15)}
    context "preconditions" do
      before :each do
        subject.stub(:rejected?) {true}
        subject.stub(:working_casual_shift_on_any_call_out_dates?) {true}
        subject.stub(:starts_at) {Time.now + 14.days + 1.hour}
      end
      it "should be true" do
        expect(subject).to have_pre_conditions_met
      end
      it "should have an array of casual shifts" do
        expect(subject.casual_shifts_on_call_out_dates).to be_a(Array)
      end
    end
    describe :the_filter do
      let(:start_date) {(Time.now + 3.weeks).at_beginning_of_week.to_date}
      let(:end_date)   {start_date + 6}
      let(:facility)  {create(:facility)}
      let(:employee_role) {create(:employees_role)}
      let(:employee1) {create(:employee, :full_time, first_name: "One")}
      let(:employee2) {create(:employee, :full_time, first_name: "Two")}
      let(:employee3) {create(:employee, :full_time, first_name: "Three")}
      let!(:monday) {create(:shift, :occuring_monday, facility: facility, employees_role: employee_role)}
      let!(:monday_to_friday) {create(:shift, :occuring_monday_to_friday, facility: facility, employees_role: employee_role)}
      let!(:daily) {create(:shift, :occuring_daily, facility: facility, employees_role: employee_role)}
      let!(:employee_shift) {create(:employee_shift, shift: daily, start_date: shift.start_date, end_date: shift.end_date, employee: employee3)}
      let!(:casual_shift) {create(:casual_shift, :vacation, start_date: start_date, end_date: end_date, shift: daily, replaced_shift: employee_shift)}
      before :each do
        [employee1, employee2, employee3].each do |employee|
          make_fully_available(employee)
        end
        create(:casual_shift, start_date: start_date, end_date: end_date, shift: monday, employee: employee1)
        create(:casual_shift, start_date: start_date, end_date: end_date, shift: monday_to_friday, employee: employee2)
      end
      it "should allow upgrading to a better option", async: true do
        expect(casual_shift.length).to eql(7)
        call_out_list = EmployeeCallOutList.create_for_call_out_shift(casual_shift, current_user)
        expect(call_out_list.eligible_employees).to include(employee1)
        expect(call_out_list.eligible_employees).to_not include(employee2)
        expect(call_out_list.eligible_employees).to_not include(employee3)
      end

    end
  end
end
