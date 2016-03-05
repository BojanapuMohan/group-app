require "spec_helper"

describe CallOut::Pipeline::OvertimeConsecutiveDaysRnAndLpnFilter do

  it_behaves_like 'a filter' do
    describe :call do
      context "without overtime" do
        it "should not call incurs_overtime!" do
          expect(filter).to_not receive(:incurs_overtime!)
          filter.call
        end
      end
      context "with overtime" do
        let(:shift) {build_stubbed(:shift, :occuring_daily, shift_type: shift_type, end_date: Date.today + 30)}
        let(:call_out_shift) {build_stubbed(:call_out_shift, shift: shift, end_date: Date.today + 5)}
        it "should be overtime if worked without 1 days off in 6" do
          expect(filter).to receive(:incurs_overtime!).at_least(:once)
          filter.call
        end
      end
    end
    describe :six_day_blocks do
      before :each do
        filter.six_day_blocks
      end
      it "should be an array of arrays" do
        expect(filter.six_day_blocks).to be_a(Array)
        expect(filter.six_day_blocks.first).to be_a(Array)
        expect(filter.six_day_blocks.first.size).to eql(6)
      end
    end

  end
  describe :the_filter do
  let(:current_user) {build_stubbed(:user)}
    let(:start_date) {Time.now.at_beginning_of_week.to_date}
    let(:end_date) {start_date + 35}
    let!(:facility) {create(:facility)}
    let!(:employee_role) {EmployeesRole.rn_role}

    let!(:employee1) {create(:employee, :casual)}
    let!(:employee2) {create(:employee, :casual)}
    let!(:employee3) {create(:employee, :casual)}
    let!(:employee4) {create(:employee, :casual)}
    let!(:employee5) {create(:employee, :casual)}
    let!(:employee6) {create(:employee, :casual)}

    let!(:shift1) {create(:shift, :on_day_of_month, dates: [1,2,3,4,5,6], employee: employee1, facility: facility, employees_role: employee_role)}
    let!(:shift2) {create(:shift, :on_day_of_month, dates: [1,2,3,4,6], employee: employee2, facility: facility, employees_role: employee_role)}
    let!(:shift3) {create(:shift, :on_day_of_month, dates: [8,9,10,11,12,13], employee: employee3, facility: facility, employees_role: employee_role)}
    let!(:shift4) {create(:shift, :on_day_of_month, dates: [8,9,10,12,13], employee: employee4, facility: facility, employees_role: employee_role)}
    let!(:shift5) {create(:shift, :on_day_of_month, dates: [7], employee: employee5, facility: facility, employees_role: employee_role)}

    let!(:casual_shift) {create(:casual_shift, shift: shift5, replaced_shift: shift5.employee_shifts.first, start_date: start_date, end_date: end_date)}

    before :each do
      make_fully_available(employee1)
      make_fully_available(employee2)
      make_fully_available(employee3)
      make_fully_available(employee4)
      make_fully_available(employee5)
      make_fully_available(employee6)
    end

    it "should work", async: true do
      call_out_list = EmployeeCallOutList.create_for_call_out_shift(casual_shift, current_user)

      expect(call_out_list.eligible_employees).to include(employee6)

      expect(call_out_list.eligible_employees).to include(employee1)
      expect(call_out_list.overtime_employees).to include(employee1)

      expect(call_out_list.eligible_employees).to include(employee2)

      expect(call_out_list.eligible_employees).to include(employee3)
      expect(call_out_list.overtime_employees).to include(employee3)

      expect(call_out_list.eligible_employees).to include(employee4)

      expect(call_out_list.eligible_employees).to_not include(employee5)
    end

  end
end
