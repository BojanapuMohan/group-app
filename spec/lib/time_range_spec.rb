require "spec_helper"
require "time_range"

describe TimeRange do
  describe :overlaps do
    let(:range) {TimeRange.new(Time.now, Time.now + 1.days)}
    let(:consecutive) {TimeRange.new(Time.now + 1.days, Time.now + 2.days)}
    let(:other_range) {TimeRange.new(Time.now + 1.hour, Time.now + 1.days)}
    let(:wide_range) {TimeRange.new(Time.now - 3.days, Time.now + 4.days)}
    let(:future_range) {TimeRange.new(Time.now + 3.days, Time.now + 4.days)}

    it "should be true if the ranges overlap" do
      expect(range.overlaps?(other_range)).to be_true
      expect(other_range.overlaps?(range)).to be_true
    end
    it "should be true if one fully spans another" do
      expect(range.overlaps?(wide_range)).to be_true
      expect(wide_range.overlaps?(range)).to be_true
    end
    it "should be true if they are the same" do
      expect(range.overlaps?(range)).to be_true
    end

    it "should be false if they don't overlap" do
      expect(range.overlaps?(future_range)).to be_false
      expect(future_range.overlaps?(range)).to be_false
    end
    it "should be false if one starts right after the other" do
      expect(range.overlaps?(consecutive)).to be_false
      expect(consecutive.overlaps?(range)).to be_false
    end
  end
end
