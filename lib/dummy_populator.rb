class DummyPopulator

  require 'factory_girl_rails'
  require 'faker'

  def self.create_employees(options = {})
    #count = 25, investor_ranks = Member.investor_ranks
    hours = (100..1500).to_a
    random = ->(max){(1..max).to_a.sample}
    facilities = Facility.enabled
    day_of_week_availabilities = DayOfWeekAvailability.all
    employee_roles = EmployeesRole.enabled
    options[:count] ||= 250
    options[:count].times do
      employee = FactoryGirl.create(:employee, seniority: hours.sample, employee_class: Employee.employee_classes.sample)
      employee.availability.save!
      puts employee.name
      facilities.shuffle.take(random.call(facilities.size)).each {|f| employee.availability.facilities << f}
      day_of_week_availabilities.shuffle.take(random.call(day_of_week_availabilities.size)).each {|a| employee.availability.day_of_week_availabilities << a}
      employee_roles.shuffle.take(random.call(2)).each {|r| employee.availability.employees_roles << r}
    end
  end
end

