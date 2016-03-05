require 'spec_helper'

describe CallOut::Pipeline::Filter do
  let(:employee_call_out) {create(:employee_call_out_with_employee)}
  let(:pipeline) {double(:pipeline)}
  let(:shift) {double(:shift)}
  let(:call_out_shift) {build_stubbed(:call_out_shift)}

  it "requires a subclass to be called" do
    expect{CallOut::Pipeline::Filter.new(pipeline, employee_call_out, call_out_shift).call}.to raise_error(NotImplementedError)
  end

  describe :call do
    let(:employee_list) {[employee_call_out]}

    it "should be called if preconditions are met" do
      CallOut::Pipeline::Filter.any_instance.should_receive(:call)
      CallOut::Pipeline::Filter.call(pipeline, employee_list, call_out_shift)
    end
    it "shouldn't be called if they are not" do
      CallOut::Pipeline::Filter.any_instance.stub(:pre_conditions) { [->(filter) {true}, ->(filter) {false} ] }
      CallOut::Pipeline::Filter.any_instance.should_not_receive(:call)
      CallOut::Pipeline::Filter.call(pipeline, employee_list, call_out_shift)
    end
    it "should stop evaluating when we hit false" do
      CallOut::Pipeline::Filter.any_instance.stub(:pre_conditions) { [->(filter) {true}, ->(filter) {false}, ->(filter){raise "Boom"} ] }
      expect{CallOut::Pipeline::Filter.call(pipeline, employee_list, call_out_shift)}.to_not raise_error
    end
  end
end
