require "spec_helper"

describe CallOut::Pipeline::SortFinder do
  subject(:sort_finder) {CallOut::Pipeline::SortFinder.new(filter)}
  describe :RnLpnCasualSorter do
  let(:filter) {double(employee_role: EmployeesRole.rn_or_lnp_roles.first)}
    it "should return rnlpn sorter if it's a rn/lpn role" do
      expect(sort_finder.sorter).to eql(CallOut::Pipeline::RnLpnCasualSorter)
    end
  end
  describe :SharedDutyShiftSorter do
  let(:filter) {double(employee_role: EmployeesRole.housekeeper_role, facility: build_stubbed(:facility, :shared_duty))}
    it "should return rnlpn sorter if it's a rn/lpn role" do
      expect(sort_finder.sorter).to eql(CallOut::Pipeline::SharedDutyShiftSorter)
    end
  end
  describe :others do
  let(:filter) {double(employee_role: EmployeesRole.food_service_or_cook_roles.first, facility: build_stubbed(:facility))}
    it "should return the default" do
      expect(sort_finder.sorter).to eql(CallOut::Pipeline::Sorter)
    end
  end
end
