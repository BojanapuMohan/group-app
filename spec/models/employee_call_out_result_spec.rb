require 'spec_helper'

describe EmployeeCallOutResult do
  describe :accepted_results do
    it "should include accepted" do
      expect(EmployeeCallOutResult.accepted_results).to include(EmployeeCallOutResult.accepted_results.first)
    end
  end
  describe :block_coverage do
    let(:result) {build_stubbed(:employee_call_out_result)}
    it "should be partial or full" do
      result.result = "Accepted - Full Block Coverage"
      expect(result.block_coverage).to eql("Full")
      result.result = "Accepted - Partial Block Coverage"
      expect(result.block_coverage).to eql("Partial")
    end
    it "should be full by default" do
      expect(result.block_coverage).to eql("Full")
    end
  end
end
