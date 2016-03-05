require 'spec_helper'

describe CallOut::Pipeline do
  class StubFilter
  end

  let(:employee_list) {[]}
  let(:call_out_shift) {double(:call_out_shift)}

  subject { CallOut::Pipeline.new(employee_list, call_out_shift) }

  describe :filters do
    before :each do
      subject.stub(:filters) {[StubFilter, StubFilter]}
    end
    it "should call the known filters" do
      StubFilter.should_receive(:call).with(subject, employee_list, call_out_shift, {}).twice
      subject.call
    end
  end
end
