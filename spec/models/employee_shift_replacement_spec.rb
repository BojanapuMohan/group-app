require 'spec_helper'

describe EmployeeShiftReplacement do
  it{should belong_to(:employee)}
  it{should belong_to(:shift_replacement_reason)}

  let(:employee) {create(:employee)}
  let(:shift) {create(:shift, :occuring_daily)}
  let!(:employee_shift) {create(:employee_shift, shift: shift, employee: employee, end_date: Date.today + 30)}
  let(:replacement)  {CallOutShift.build_from_shift_occurence(employee_shift.occurrences.first)}

  it "should be for an employee whose shift has been replaced for any reason" do
    replacement.start_date = Date.today
    replacement.end_date = Date.today + 7
    replacement.shift_replacement_reason = ShiftReplacementReason.self_cancelled
    #expect{replacement.save!}.to change{EmployeeShiftReplacement.count}.by(1)
    replacement.save!
    expect(employee).to have(1).employee_shift_replacement
    expect(employee.employee_shift_replacements.first.shift_replacement_reason).to eql(ShiftReplacementReason.self_cancelled)
  end

end
