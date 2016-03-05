class ScheduledShift < EmployeeShift
  def regular_shift?
    true
  end

  def casual_shift?
    false
  end
end
