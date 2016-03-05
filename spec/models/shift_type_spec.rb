require 'spec_helper'

describe ShiftType do
  let(:shift_type) {build_stubbed(:shift_type)}
  describe :duration do
    it "should be stored in minutes but returned in hours" do
      shift_type.duration = 600
      expect(shift_type.duration).to eql(10.0)
      shift_type.duration = (6.5 * 60)
      expect(shift_type.duration).to eql(6.5)
    end
  end
end
