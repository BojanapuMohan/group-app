require 'spec_helper'

describe EmployeesRole do
  describe :shared_duty_roles do
    it "should have 2 roles" do
      expect(EmployeesRole.shared_duty_roles).to have(2).employees_roles
    end
  end
  it "should know a house keeper" do
    expect(EmployeesRole.housekeeper_role).to be_housekeeper
  end
  it "should have an rn and lpn_role role" do
    expect(EmployeesRole.rn_role).to be_a(EmployeesRole)
    expect(EmployeesRole.lpn_role).to be_a(EmployeesRole)
    expect(EmployeesRole.rn_or_lnp_roles).to include(EmployeesRole.rn_role)
    expect(EmployeesRole.rn_or_lnp_roles).to include(EmployeesRole.lpn_role)
  end
  describe :replaceable_roles do
    let(:role) {build_stubbed(:employees_role)}
    it "should normally be self" do
      expect(role.replaceable_roles).to eql([role])
    end
    it "should be shared_duty_roles if it's a housekeeper" do
      expect(EmployeesRole.housekeeper_role.replaceable_roles).to eql(EmployeesRole.shared_duty_roles)
    end
  end
end
