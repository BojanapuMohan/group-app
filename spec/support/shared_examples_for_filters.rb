def make_fully_available(employee)
  availability = employee.availability
  DayOfWeekAvailability.setup
  EmployeesRole.all.each {|role| availability.employees_roles << role}
  Facility.all.each {|facility| availability.facilities << facility}
  DayOfWeekAvailability.all.each {|dow| availability.day_of_week_availabilities << dow}
  employee.save!
  availability.save!
end

shared_examples "a filter" do
  let(:start_date) {Time.now.to_date}
  let(:end_date) {start_date + 30}
  let(:current_user) {build_stubbed(:user)}
  let(:employee) {build_stubbed(:employee)}
  let(:shift_type) {build_stubbed(:shift_type)}
  let(:shift) {build_stubbed(:shift, shift_type: shift_type, end_date: end_date)}
  let(:employee_shift) {build_stubbed(:employee_shift, shift: shift, employee: employee, start_date: start_date, end_date: end_date)}
  let(:employee_call_out_list) {build_stubbed(:employee_call_out_list, call_out_shift: call_out_shift)}
  let(:employee_call_out) {build_stubbed(:employee_call_out, employee: employee, employee_call_out_list: employee_call_out_list)}
  let(:call_out_shift) {build_stubbed(:call_out_shift, shift: shift, end_date: start_date + 7)}
  let!(:pipeline) {CallOut::Pipeline.new([employee_call_out], call_out_shift)}

  subject(:filter) { described_class.new(pipeline, employee_call_out, call_out_shift) }

  it "should have a preconditions array" do
    expect(subject.pre_conditions).to be_a(Array)
  end

  it "should have callable preconditions" do
    subject.pre_conditions.each do |pc|
      expect(pc).to respond_to(:call)
    end
  end

  it "should have boolean called preconditions" do
    subject.pre_conditions.each do |pc|
      expect(pc.call(subject)).to be_in([true, false])
    end
  end

  it "should be a loaded filter" do
    expect(CallOut::Pipeline.new([employee_call_out], call_out_shift).filters).to include(described_class)
  end

  it "shouldn't blow up when called" do
    expect{subject.call}.to_not raise_error
  end

end

