require 'spec_helper'

describe EmployeeCallOut do
  it{should belong_to(:employee_call_out_list)}
  it{should belong_to(:employee)}
  it{should belong_to(:employee_call_out_result)}

  describe :filter_actions do
    let(:employee_call_out) {create(:employee_call_out)}
    it "should allow reject!" do
      employee_call_out.reject!("foo")
      expect(employee_call_out).to be_rejected
      expect(employee_call_out.reload).to be_rejected
      expect(employee_call_out.rule).to eql(["foo"])
    end
    it "should allow accept!" do
      employee_call_out.reject!("foo")
      employee_call_out.accept!("foo")
      expect(employee_call_out.reload).to be_eligible
      expect(employee_call_out.rule).to eql([ "foo", "foo"])
    end
    it "should concat rules" do
      employee_call_out.reject!("foo")
      employee_call_out.accept!("bar")
      expect(employee_call_out.rule).to eql(['foo',  'bar'])
      expect(employee_call_out.reload.rule).to eql(['foo',  'bar'])
    end
  end

  describe :dup do
    let!(:employee_call_out) {create(:employee_call_out)}
    it "should create a new record" do
      expect{employee_call_out.dup}.to change{EmployeeCallOut.count}.by(1)
    end
    it "should not dup the called_at or the result" do
      employee_call_out.update_attributes(called_at: Time.now, employee_call_out_result: EmployeeCallOutResult.declined_results.sample)
      duplicate = employee_call_out.dup
      expect(duplicate.called_at).to be_blank
      expect(duplicate.employee_call_out_result).to be_blank
    end

  end
end
