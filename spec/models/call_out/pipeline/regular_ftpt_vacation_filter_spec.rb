require "spec_helper"

describe CallOut::Pipeline::RegularFtptVacationFilter do

  it_behaves_like 'a filter' do
    context "preconditions" do
      before :each do
      end
    end
    describe :the_filter do
      let(:end_date)   {start_date + 13}
      let(:employee) {create(:employee, :full_time)}
      let(:employee1) {create(:employee, :full_time)}
      let!(:shift) {create(:shift, :occuring_daily, start_date: start_date, end_date: end_date)}
      let!(:employee_shift) {create(:employee_shift, shift: shift, employee: employee, start_date: start_date, end_date: end_date)}
      let!(:call_out_shift) {create(:casual_shift, :vacation, shift: shift, replaced_shift: employee_shift, start_date: start_date, end_date: start_date + 6)}
      before :each do
        [employee, employee1].each do |employee|
          make_fully_available(employee)
        end
      end
      it "should know if the employee is on vacation" do
        expect(employee).to be_on_vacation(start_date)
        expect(employee).to be_on_vacation(start_date, start_date + 1)
      end
      it "should know regularly scheduled dates" do
        expect(employee.regular_shifts_scheduled_between(start_date, end_date)).to have(14).shift_occurences
      end
      it "should know if the vacationd days overlap scheduled days" do
        expect(subject).to be_on_regularly_scheduled_dates
      end
    end
  end
end
