require 'spec_helper'

describe Shift do
  it{should belong_to(:facility)}
  it{should belong_to(:employees_role)}
  it{should belong_to(:shift_type)}
  it{should have_many(:employee_shifts)}
  it{should have_many(:scheduled_shifts)}
  it{should have_many(:call_out_shifts)}
  

  describe :start_time do
    it "should be built from the hour and minute" do
      subject.start_hour = 3
      subject.start_minute = "15"
      expect(subject.start_time).to eql("03:15")
      subject.start_hour = "22"
      expect(subject.start_time).to eql("22:15")
    end
  end

  describe :ice_cube do
  let(:rule) {"{\"interval\":1,\"until\":null,\"count\":null,\"validations\":{\"day\":[1,3,5]},\"rule_type\":\"IceCube::WeeklyRule\"}"}
    let(:shift) {build(:shift)}
    it "should handle a nil schedule" do
      expect(subject.schedule).to be_nil
    end
    it "should store the schedule" do
      shift.schedule_store = rule
      shift.save!
      shift.reload
      expect(shift.schedule).to be_a(IceCube::Schedule)
    end
    describe :occurrences do
      subject(:shift) {build_stubbed(:shift, schedule_store: rule, start_date: Date.today, end_date: Date.today + 10)}
      it "should return the single occurence if there is no recurrence" do
        shift.schedule_store = 'null'
        expect(shift.occurrences.size).to eql(1)
        expect(shift.occurrences).to include(ShiftOccurrence.new(shift.start_date, shift))
      end
      it "should count occurrences" do
        #this might fail some days as the calendar advances
        expect(shift.occurrences.size).to eql(5)
      end
      it "should allow start and end options" do
        occurrences = shift.occurrences(Date.today, Date.today + 6)
        expect(occurrences.size).to eql(3)
      end
    end
  end
  describe :scopes do
    describe :current do
      let!(:today) {create(:shift, start_date: Date.today, end_date: Date.today)}
      let!(:today_and_forever) {create(:shift, start_date: Date.today, end_date: nil)}
      let!(:future) {create(:shift, start_date: Date.today + 5, end_date: Date.today + 5)}
      let!(:yesterday) {create(:shift, start_date: Date.today - 7, end_date: Date.today - 1)}
      subject(:scope) {Shift.current}
      it {should_not include(yesterday)}
      it {should include(today)}
      it {should include(future)}
      it {should include(today_and_forever)}
    end
  end
end


