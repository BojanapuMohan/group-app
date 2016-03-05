require "spec_helper"

describe CallOut::Pipeline::OvertimeInLastTwentyFourHoursFilter do
  it_behaves_like 'a filter' do
    describe :overtime_limit do
      it "should be 10 hours for food service" do
        subject.stub(:employee_role) {EmployeesRole.food_service_or_cook_roles.sample}
        expect(subject.overtime_limit).to eql(10.0)
      end
      it "should be 8 hours" do
        expect(subject.overtime_limit).to eql(8.0)
      end
    end
    context "should mark overtime " do
      it "if the employee would have more than 8 hours in the last 24" do
        pending "Requires update for occurence_calculator"
        shift_type.stub(:duration) {8}
        employee.stub(:hours_worked_between) {0.1}
        subject.should_receive(:incurs_overtime!)
        subject.call
      end
    end
    it "should not mark overtime with less than 8 hours in the last 24" do
      shift_type.stub(:duration) {8}
      employee.stub(:hours_worked_between) {0}
      subject.should_not_receive(:incurs_overtime!)
      subject.call
    end
  end
end
