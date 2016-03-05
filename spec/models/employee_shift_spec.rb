require 'spec_helper'

describe EmployeeShift do
  it {should belong_to(:shift)}
  it {should have_one(:facility)}
  it {should have_one(:employees_role)}
  it {should belong_to(:employee)}
  it {should have_many(:employee_call_out_lists)}
  let(:today) {Time.now.to_date}
  let(:shift) {build_stubbed(:shift, :occuring_daily, time_of_day: "Morning")}
  subject(:employee_shift) {build_stubbed(:employee_shift, start_date: today, end_date: today + 6, shift: shift)}

  it{should be_regular_shift}
  it{should_not be_casual_shift}

  describe :time_of_day do
    it "should get the time_of_day from the shift" do
      expect(employee_shift.time_of_day).to eql(shift.time_of_day)
    end
  end
  describe :occurences do
    it "should only include occurrences within it's date range" do
      expect(employee_shift.occurrences).to have(7).shift_occurences
    end
    it "should only query within it's date range" do
      expect(employee_shift.occurrences_between(today - 10, today + 50)).to have(7).shift_occurences
    end
  end
  describe :occurences_between do
    it "should include occurences within the shift dates" do
      expect(employee_shift.occurrences_between(today, today + 1)).to have(2).shift_occurences
    end
    it "shouldn't include days starting before" do
      expect(employee_shift.occurrences_between(today - 50, today + 1)).to have(2).shift_occurences
    end
    it "shouldn't count days after" do
      expect(employee_shift.occurrences_between(today, today + 100)).to have(7).shift_occurences
    end
  end
  describe :days_of_week do
    let(:shift) {build_stubbed(:shift, :occuring_daily, start_date: today, end_date: today)}
    it "should include the days of the week for the shift [0-6]" do
      expect(employee_shift.days_of_week).to eql([today.wday])
    end
    context "over several weeks" do
      let(:shift) {build_stubbed(:shift, :occuring_daily, end_date: Date.today + 30)}
      subject(:employee_shift) {build_stubbed(:employee_shift, shift: shift, end_date: shift.end_date)}
      it "shouldn't repeat the days" do
        expect(employee_shift.days_of_week).to eql([0,1,2,3,4,5,6])
      end
    end
  end
end
