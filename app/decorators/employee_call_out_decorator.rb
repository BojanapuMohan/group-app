class EmployeeCallOutDecorator < Draper::Decorator
  decorates :employee_call_out
  delegate_all

  def tr_class
    object.overtime? ? 'overtime' : 'regular_time'
  end

  def called_at
    return '' unless object.called_at.present?
    object.called_at.strftime('%c')
  end

  def block_coverage
    object.employee_call_out_result.try(:block_coverage)
  end

end
