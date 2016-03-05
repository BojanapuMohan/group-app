class EmployeeShiftReplacement < ActiveRecord::Base
  belongs_to :employee
  belongs_to :shift_replacement_reason
end
