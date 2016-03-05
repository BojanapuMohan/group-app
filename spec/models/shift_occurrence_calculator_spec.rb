require 'spec_helper'

describe ShiftOccurrenceCalculator do
  let(:shift) {build_stubbed(:shift)}
  let(:today) {Time.now.to_date}
  let(:tomorrow) {today + 1}
  let(:shift_occurence) {ShiftOccurrence.new(today, shift)}
  let(:shift_occurence2) {ShiftOccurrence.new(tomorrow, shift)}
  let(:calculator) {ShiftOccurrenceCalculator.new([shift_occurence, shift_occurence, shift_occurence2])}

  describe :<< do
    it "should add items" do
      expect{calculator << ShiftOccurrence.new(tomorrow + 5, shift)}.to change{calculator.occurrences.size}.by(1)
    end
    it "should sort the collection" do
      calculator << ShiftOccurrence.new(tomorrow + 5, shift)
      calculator << ShiftOccurrence.new(tomorrow + 1, shift)
      expect(calculator.occurrences.last.date).to eql(tomorrow + 5)
    end
  end
  describe :+ do
    it "should add items individually" do
      size = calculator.occurrences.size
      expect{calculator + ShiftOccurrence.new(tomorrow + 5, shift)}.to change{calculator.occurrences.size}.by(1)
      expect(calculator.occurrences.size).to eql(size + 1)
    end
    it "should add items as an array" do
      size = calculator.occurrences.size
      expect{calculator + [ShiftOccurrence.new(tomorrow + 5, shift), ShiftOccurrence.new(tomorrow + 5, shift)]}.to change{calculator.occurrences.size}.by(2)
      expect(calculator.occurrences.size).to eql(size + 2)
    end
  end

  describe :shifts_between do
    it "should just select the shifts by date" do
      expect(calculator.shifts_between(tomorrow, tomorrow + 5)).to include(shift_occurence2)
      expect(calculator.shifts_between(tomorrow, tomorrow + 5).size).to eql(1)
    end
  end

  describe :durations_per_day do
    it "should be a hash" do
      expect(calculator.durations_per_day).to be_a(Hash)
    end
    it "should sum same day durations" do
      expect(calculator.durations_per_day).to eql({today => 16.0, tomorrow => 8.0})
    end
  end
  describe :breaks_between_shifts do
    it "should be a hash" do
      expect(calculator.breaks_between_shifts).to be_a(Hash)
    end
    it "should include the time between shifts" do
      expect(calculator.breaks_between_shifts).to eql({today => 0, tomorrow => 16.0})
    end
  end
end

describe ShiftOccurrenceCalculatorItem do
  let(:today) {Time.now.to_date}
  let(:tomorrow) {today + 1}
  let(:shift) {build_stubbed(:shift)}
  let(:shift_occurence) {ShiftOccurrence.new(today, shift)}

  let(:calculator_item) {ShiftOccurrenceCalculatorItem.new(shift_occurence)}

  describe :duration_per_24_hour_period do
    it "should return a hash" do
      #raise occurrence.duration_per_24_hour_period.inspect
      expect(calculator_item.duration_per_24_hour_period).to be_a(Hash)
    end
    context "same day" do
      it "should return 1 value with todays hours" do
        expect(calculator_item.duration_per_24_hour_period).to eql({today => 8.0})
      end
    end
    context "over midnight" do
      it "should have 2 values" do
        shift.start_hour = 20
        expect(calculator_item.duration_per_24_hour_period).to eql({today => 4.0, tomorrow => 4.0})
      end
    end
  end

end
