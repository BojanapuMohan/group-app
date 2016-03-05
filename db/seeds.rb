# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# Environment variables (ENV['...']) can be set in the file config/application.yml.
# See http://railsapps.github.io/rails-environment-variables.html

puts 'ROLES'
old_admin = Role.where(name: 'admin').first # fix renamed seed
old_admin.update_attribute(:name, 'administrator') if old_admin.present?

%w{scheduler coordinator administrator}.each do |role|
  Role.where(name: role).first_or_create
  puts 'role: ' << role
end
puts 'DEFAULT USERS'
user = User.find_or_create_by_email :name => ENV['ADMIN_NAME'].dup, :email => ENV['ADMIN_EMAIL'].dup, :password => ENV['ADMIN_PASSWORD'].dup, :password_confirmation => ENV['ADMIN_PASSWORD'].dup
puts 'user: ' << user.name
user.confirm!
user.add_role :administrator

employee_roles = [
  ["Shelter Support Worker" ,"SSW"],
  ["Cook", "CK"],
  ["Registered Nurse", "RN"],
  ["In-Reach Worker", "IRW"],
  ["Shift Team Lead", "STL"],
  ["Housekeeper", "HK"],
  ["Second Stage Support Worker", "SSSW"],
  ["Child and Youth Worker", "CYW"],
  ["Shelter Cook", "SCK"],
  ["Food Service Worker", "FSW"],
  ["Mental Health worker", "MHW"],
  ["Licensed Practical Nurse", "LPN"],
  ["Care Aide", "CA"],
  ["Data Entry Clerk", "DEC"],
  ["Tenant Relations Worker", "TRW"],
  ["Laundry Shift", "LS"]
]
puts 'Adding Employee Roles'
employee_roles.each {|role|  puts role.join(" - "); EmployeesRole.where(role_name: role[0], role_abbreviation: role[1]).first_or_create }

shift_replacement_reasons = [
  ["Sick Leave", "SL"],
  ["Leave of Absence", "LOA"],
  ["Vacation", "V"],
  ["Special Leave", "SPL"],
  ["Unpaid Leave", "UP"],
  ["Statutory Holiday", "STAT"],
  ["Orientation", "OR"],
  ["Self Cancelled", "SC"],
  ["Education/Training Leave", "ED"],
  ["Union Business", "UB"],
  ["Banked Overtime", "BOT"],
  ["Banked STAT", "BSTAT"],
  ["Compassionate Leave", "CL"]
]
puts 'Adding Shift Replacement Reasons'
shift_replacement_reasons.each {|reason|  puts reason.join(" - "); ShiftReplacementReason.where(reason: reason[0], abreviation: reason[1]).first_or_create }

facilities = [
  ["Victory House"],
  ["Cordova House"],
  ["Springhouse"],
  ["Powell Place"],
  ["Cottage Hospice"],
  ["May's Place Hospice"],
  ["Santiago Lodge"]
]
puts 'Adding Facilities'
facilities.each {|facility|  puts facility.join(" - "); Facility.where(name: facility[0]).first_or_create }

puts('Adding dayofweekavailabilities')
DayOfWeekAvailability.setup

puts "Adding Shift Types"

shift_types = [
  ["General: 8 hours total (0.5 hour break)", 8 * 60],
  ["Food Service and Cooks: 10 hours total (1 hour break)", 10 * 60],
  ["Laundry, Care aids and Cooks: 6.5 hours (0.5 hour break)", 6.5 * 60],
  ["Work load shift 4 hours total (0 hour break)", 4.0 * 60]
]

shift_types.each {|st| puts st.to_s; ShiftType.where(name: st[0]).first_or_create.update_attributes(duration: st[1])}

puts "Adding Call Results"

a = EmployeeCallOutResult.find_by_result("Accepted") # fix renamed seed
a.update_attribute(:result, "Accepted - Full Block Coverage") if a

EmployeeCallOutResult.accepted_results.each {|r| puts r.result}
EmployeeCallOutResult.declined_results.each {|r| puts r.result}
EmployeeCallOutResult.no_answer_results.each {|r| puts r.result}

