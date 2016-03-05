class EmployeesRole < ActiveRecord::Base

  include CanEnable

  default_scope {order("role_abbreviation")}

  def to_s
    "#{role_abbreviation} - #{role_name}"
  end

  def housekeeper?
    self == self.class.housekeeper_role
  end

  def replaceable_roles
    housekeeper? ? EmployeesRole.shared_duty_roles : [self]
  end

  def self.shared_duty_roles
    [housekeeper_role, shelter_support_worker_role]
  end

  def self.food_service_or_cook_roles
    [["Cook", "CK"], ["Food Service Worker", "FSW"]].map {|(name, abreviation)| find_or_create_by_name_and_abreviation(name, abreviation) }
  end

  def self.rn_or_lnp_roles
    [rn_role, lpn_role]
  end

  def self.rn_role
    find_or_create_by_name_and_abreviation("Registered Nurse", "RN")
  end

  def self.lpn_role
    find_or_create_by_name_and_abreviation("Licensed Practical Nurse", "LPN")
  end

  def self.housekeeper_role
     find_or_create_by_name_and_abreviation("Housekeeper", "HK")
  end

  def self.shelter_support_worker_role
    find_or_create_by_name_and_abreviation("Shelter Support Worker", "SSW")
  end

  def self.find_or_create_by_name_and_abreviation(name, abreviation)
    where(role_name: name, role_abbreviation: abreviation).first_or_create
  end

end

