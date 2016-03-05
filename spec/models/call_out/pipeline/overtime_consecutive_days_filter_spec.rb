require "spec_helper"

describe CallOut::Pipeline::OvertimeConsecutiveDaysFilter do

  it_behaves_like 'a filter' do
    context "preconditions" do
      before :each do
      end
    end
    describe :call do
      context "without overtime" do
        it "should not call incurs_overtime!" do
          expect(filter).to_not receive(:incurs_overtime!)
          filter.call
        end
      end
      context "with overtime" do
        let(:shift) {build_stubbed(:shift, :occuring_daily, shift_type: shift_type, end_date: Date.today + 30)}
        let(:call_out_shift) {build_stubbed(:call_out_shift, shift: shift, end_date: Date.today + 8)}
        it "should be overtime if worked without 2 consecutive days off in 8" do
          expect(filter).to receive(:incurs_overtime!).at_least(:once)
          filter.call
        end
      end
    end
    describe :breaks_in_eight_day_blocks do
      before :each do
        filter.eight_day_blocks_with_consecutive_days
      end
      it "should be an array of arrays" do
        expect(filter.breaks_in_eight_day_blocks).to be_a(Array)
        expect(filter.breaks_in_eight_day_blocks.first).to be_a(Array)
      end
    end
  end
end
