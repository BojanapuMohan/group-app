require "spec_helper"

describe ShiftOccurrence do
  let(:facility) {build_stubbed(:facility)}
  let(:shift) {build_stubbed(:shift)}
  let(:date)  {Date.today}
  describe :== do
    it "should be eql if the shift and date match" do
      expect(ShiftOccurrence.new(date, shift) == ShiftOccurrence.new(date, shift)).to be_true
    end
  end
  describe :date_time do
    let(:shift) { build_stubbed(:shift, :with_facility_and_role, start_hour: 5, start_minute: 30)}
    let(:occurrence) {ShiftOccurrence.new(Date.today, shift)}
    it "should be built from the date and start times" do
      expect(occurrence.date_time).to eql(Time.now.change(hour: 5, min: 30))
    end
    it "should have an end time" do
      shift.stub(:duration) {2}
      expect(occurrence.end_time).to eql(Time.now.change(hour: 7, min: 30))
      shift.stub(:duration) {24}
      expect(occurrence.end_date).to eql(Date.tomorrow)
    end
    describe :break_since do
      let(:other_occurrence) {ShiftOccurrence.new(Date.yesterday, shift)}
      it "should calculate" do
        expect(occurrence.break_since(other_occurrence)).to eql(16.0)
      end
    end
  end
  describe :shift_types do
    let(:start_date) {Date.today}
    let(:end_date)   {start_date + 6}
    let!(:daily) {create(:shift, :occuring_daily, facility: facility)}
    let(:employee) {create(:employee)}
    let!(:employee_shift) {create(:employee_shift, employee: employee, shift: daily, start_date: start_date)}
    subject {ShiftOccurrence.new(start_date, daily)}
    context "regular_employee_shift?" do
      it "should be true if the shift is an employee_shift" do
        expect(subject).to be_regularly_scheduled_shift(employee)
        expect(subject).to_not be_casual_shift(employee)
      end
    end
    context "casual_shift?" do
      let(:employee2) {create(:employee)}
      let!(:casual_shift) {create(:casual_shift, :vacation, employee: employee2, start_date: start_date, end_date: end_date, shift: daily, replaced_shift: employee_shift)}
      it "should be true if there is an over lying casual shift" do
        expect(subject).to be_casual_shift(employee2)
        expect(subject).to_not be_regularly_scheduled_shift(employee2)
        expect(subject).to be_regularly_scheduled_shift(employee)
      end

    end
  end

  describe :employee_shifts, async: true do
    let(:shift) {create(:shift, :with_facility_and_role, :current)}
    let!(:employee_shift) {create(:employee_shift, shift: shift, start_date: date - 1, end_date: date + 1)}
    subject(:occurrence) {ShiftOccurrence.new(date, shift)}
    it "should be the shifts employee_shifts" do
      expect(occurrence.employee_shifts).to include(employee_shift)
    end
    describe :employee_call_out_lists do
      let(:user) {build_stubbed(:user)}
      let(:call_out_shift) {CallOutShift.create(shift: shift, replaced_shift: employee_shift, start_date: Date.today, end_date: Date.today)}
      let!(:call_out_list) {EmployeeCallOutList.create_for_call_out_shift(call_out_shift, user)}
      it "should be the employee_shifts call out lists" do
        expect(occurrence.employee_call_out_lists).to include(call_out_list)
      end
      it "should be an enumerator" do
        expect(occurrence.employee_call_out_lists).to respond_to(:each)
        expect(occurrence.employee_call_out_lists).to respond_to(:map)
      end
    end
  end
end
