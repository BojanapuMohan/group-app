class Availability < ActiveRecord::Base
  belongs_to :employee
  has_and_belongs_to_many :facilities
  has_and_belongs_to_many :day_of_week_availabilities, join_table: 'availability_day_of_week_availability'
  has_and_belongs_to_many :employees_roles

  scope :for_facility, -> (facility) {joins(:facilities).where(facilities: {id: facility.id})}
  scope :for_roles, ->(roles) {joins(:employees_roles).where(employees_roles: {id: roles.map(&:id)})}
  scope :for_role, ->(role) {for_roles(Array(role))}
  scope :for_time_of_day_and_days_of_week, ->(time_of_day, days_of_week) {joins(:day_of_week_availabilities).where(day_of_week_availabilities: {day_of_week: days_of_week, time_of_day: time_of_day})}
  scope :for_enabled_employees, ->() {includes(:employee).where(employees: {enabled: true})}

  def self.for_facility_on_days_for_role(facility, time_of_day, days_of_week, employees_role)
    for_enabled_employees.for_facility(facility).for_roles(employees_role.replaceable_roles).for_time_of_day_and_days_of_week(time_of_day, days_of_week)
  end

end
