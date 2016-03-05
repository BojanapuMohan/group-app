require 'spec_helper'

describe Availability do
  it {should belong_to(:employee)}
  it {should have_and_belong_to_many(:facilities)}
  it {should have_and_belong_to_many(:day_of_week_availabilities)}
  it {should have_and_belong_to_many(:employees_roles)}

  describe :scopes do
    let(:facility) {create(:facility)}
    let(:role) {EmployeesRole.create(role_name: "Test role")}
    let(:day_of_week_availability) {create(:day_of_week_availability, time_of_day: "Morning", day_of_week: 0)}
    let!(:availability) {create(:availability)}
    let!(:other_availability) {create(:availability)}
    describe :for_facility do
      before :each do
        availability.facilities << facility
      end
      subject {Availability.for_facility(facility)}
      it {should include(availability)}
      it {should_not include(other_availability)}
    end
    describe :for_role do
      before :each do
        availability.employees_roles << role
      end
      subject {Availability.for_role(role)}
      it {should include(availability)}
      it {should_not include(other_availability)}
    end
    describe :for_time_of_day_and_days_of_week do
      before :each do
        availability.day_of_week_availabilities << day_of_week_availability
      end
      subject {Availability.for_time_of_day_and_days_of_week("Morning", 0)}
      it {should include(availability)}
      it {should_not include(other_availability)}
      context "with an array of days" do
        subject {Availability.for_time_of_day_and_days_of_week("Morning", [0,1])}
        it {should include(availability)}
        it {should_not include(other_availability)}
      end
    end
    describe :for_facility_on_days_for_role do
      let(:employee) {create(:employee)}
      before :each do
        employee.availability = availability
        employee.save!
        availability.facilities << facility
        availability.employees_roles << role
        availability.day_of_week_availabilities << day_of_week_availability
        other_availability.facilities << facility
        other_availability.day_of_week_availabilities << day_of_week_availability
      end
      subject {Availability.for_facility_on_days_for_role(facility, "Morning", [0,1], role)}
      it {should include(availability)}
      it {should_not include(other_availability)}
      it "should not include disabled employees" do
        employee.disable!
        expect(subject).to_not include(availability)
      end
    end
  end
end
