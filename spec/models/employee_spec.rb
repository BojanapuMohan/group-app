require 'spec_helper'

describe Employee do
  describe :availability do
    it {should have_one(:availability)}
    it {should have_many(:employee_shifts)}
    it {should have_many(:vacations)}

    it "should proxy to a built availability if new" do
      expect(subject.availability).to be_a(Availability)
    end
    context "shifts" do
      let(:employee) {create(:employee)}
      let(:today) {Time.now.to_date}
      let(:tomorrow) {today + 1}
      let(:shift) {create(:shift, :occuring_daily, start_date: today - 5, end_date: today + 5)}
      let!(:employee_shift) { create(:employee_shift, employee: employee, shift: shift, start_date: shift.start_date, end_date: shift.end_date)}

      describe :scheduled_between do
        it "should include scheduled occurences" do
          expect(employee.shifts_scheduled_between(today, today + 20).size).to eql(6)
        end
        describe :scheduled_between? do
          context "should be true" do
            it "if the employee is scheduled during that period" do
              expect(employee).to be_scheduled_between(today, tomorrow)
            end
            it "if the employee is scheduled but replaced" do
              create(:casual_shift, replaced_shift: employee_shift, shift: shift, start_date: today, end_date: today + 2)
              expect(employee).to be_scheduled_between(today, tomorrow)
            end
          end
          it "should be false if the employee is not scheduled during that period" do
            expect(employee).to_not be_scheduled_between(today + 6, today + 10)
          end
        end
      end
      describe :shifts_worked_between do
        it "should be an array of shift occurrences" do
          expect(employee.shifts_worked_between(today, today + 20).size).to eql(6)
          expect(employee.shifts_worked_between(today, today + 20).first).to be_a(ShiftOccurrence)
        end
        it "should not include replaced shifts" do
          create(:casual_shift, employee: create(:employee), shift: shift, replaced_shift: employee_shift, start_date: today, end_date: today)
          expect(employee.shifts_worked_between(today, today + 20).size).to eql(5)
        end
      end
      describe :regular_shifts_scheduled_between do
        it "should be an array of shift occurrences" do
          expect(employee.regular_shifts_scheduled_between(today, today + 20)).to have(6).shift_occurences
          expect(employee.regular_shifts_scheduled_between(today - 20, today + 20)).to have(11).shift_occurences
        end
        it "shouldn't include casual shifts" do
          create(:casual_shift, :vacation, shift: create(:shift, :occuring_daily), employee: employee, start_date: today, end_date: today + 7)
          expect(employee.regular_shifts_scheduled_between(today - 20, today + 20)).to have(11).shift_occurences
        end
      end
    end

  end
end
