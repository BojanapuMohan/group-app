require 'spec_helper'

describe Vacation do
  it {should belong_to(:employee)}
  it {should belong_to(:shift)}
  it {should have_one(:facility)}

  let(:today) {Time.now.to_date}
  let(:employee) {create(:employee)}
  let(:shift) {create(:shift, :occuring_daily)}
  let!(:employee_shift) {create(:employee_shift, shift: shift, employee: employee, end_date: today + 30)}

  it "should be for an employee whose shift has been replaced for the reason 'Vacation'" do
    expect(employee).to_not be_on_vacation(today)
    expect(employee).to_not be_on_vacation(today, today + 7)
    expect(employee).to be_scheduled_between(today, today + 7)
    replacement = CallOutShift.build_from_shift_occurence(employee_shift.occurrences.first)
    replacement.start_date = today
    replacement.end_date = today + 7
    replacement.shift_replacement_reason = ShiftReplacementReason.vacation
    replacement.save!
    expect(employee).to be_on_vacation(today)
    expect(employee).to be_on_vacation(today + 1)
    expect(employee).to be_on_vacation(today, today + 7)
    #expect(employee).to_not be_on_vacation(today, today + 9)
  end

end
