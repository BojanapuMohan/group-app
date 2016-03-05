require "spec_helper"
require "time_range"

describe CallOut::Pipeline::AlreadyWorkingFilter do

  it_behaves_like 'a filter' do
    let(:range) {TimeRange.new(Time.now, Time.now + 1.days)}
    let(:consecutive) {TimeRange.new(Time.now + 1.days, Time.now + 2.days)}
    let(:other_range) {TimeRange.new(Time.now + 1.hour, Time.now + 1.days)}
    it "should reject an already working employee" do
      employee.stub(:shifts_worked_between) {[double(time_range: range), double(time_range: other_range)]}
      subject.stub(:shift_time_ranges) {[other_range]}
      subject.should_receive(:reject!)
      subject.call
    end

    it "shouldn't reject a free employee" do
      subject.should_not_receive(:reject!)
      subject.call
    end
  end

end
