require 'spec_helper'

describe DayOfWeekAvailability do
  it{should have_and_belong_to_many(:availabilities)}

  describe :week_day do
    it "should be nil of the day_of_week is blank" do
      subject.day_of_week = nil
      expect(subject.week_day).to eql(nil)
    end
    it "should be the week day" do
      subject.day_of_week = 1
      expect(subject.week_day).to eql("Monday")
    end
  end
end
