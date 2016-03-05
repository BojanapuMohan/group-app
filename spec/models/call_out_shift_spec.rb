require "spec_helper"

describe CallOutShift do
  it {should be_a(EmployeeShift)}
  it {should belong_to(:replaced_shift)}
  it {should belong_to(:shift_replacement_reason)}

  describe :sti do
    before :each do
      subject.save!
    end
    it {should be_persisted}
    it {should be_a(CallOutShift)}
    it {should be_a(EmployeeShift)}
  end

   it{should_not be_regular_shift}
  it{should be_casual_shift}

  describe :fill_in_shift do
    let!(:call_out_shift) {create(:call_out_shift, start_date: Date.today, end_date: Date.today + 7)}
    it "shouldn't do anything if the end date is not changed" do
      expect{call_out_shift.save}.to_not change{CallOutShift.count}
    end
    it "should create a new call_out_shift if the end_date is changed" do
      call_out_shift.end_date = Date.today + 2
      expect{call_out_shift.save}.to change{CallOutShift.count}.by(1)
      expect(call_out_shift.add_on_shift).to be_present
    end
  end

end
