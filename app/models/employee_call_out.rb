class EmployeeCallOut < ActiveRecord::Base
  belongs_to :employee_call_out_list, touch: true
  has_one :call_out_shift, through: :employee_call_out_list
  has_one :facility, through: :employee_call_out_list
  belongs_to :employee
  belongs_to :employee_call_out_result

  delegate :name, :phone, :seniority, to: :employee, prefix: true, allow_nil: false

  default_scope ->{order(:position, :created_at)}
  scope :eligible, ->{where(rejected: false)}

  def accepted_by_employee?
    EmployeeCallOutResult.accepted_results.include?(employee_call_out_result)
  end

  def update_call_out(params)
    params.merge!(called_at: Time.now)
    self.update_attributes(params)
  end

  def incurs_overtime!(rule_name)
    update_rule!(:overtime, true, rule_name)
  end

  def reject!(rule_name)
    update_rule!(:rejected, true, rule_name)
  end

  def accept!(rule_name)
    update_rule!(:rejected, false, rule_name)
  end

  def dup
    duplicate = super
    duplicate.update_attributes(called_at: nil, employee_call_out_result: nil)
    duplicate
  end

  def eligible?
    !rejected?
  end

  def regular_time?
    !overtime?
  end

  def availability
    employee.availability
  end

  private

  def update_rule!(field, value, rule_name)
    self.rule = rule +  [rule_name]
    self.send("#{field}=", value)
    self.save!
  end

end
