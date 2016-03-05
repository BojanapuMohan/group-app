class EmployeeCallOutList < ActiveRecord::Base
  belongs_to :user
  belongs_to :call_out_shift
  has_one :facility, through: :call_out_shift
  has_many :employee_call_outs
  has_many :eligible_employees, -> { where(employee_call_outs: {rejected: false}) }, through: :employee_call_outs, source: :employee
  has_many :overtime_employees, -> { where(employee_call_outs: {overtime: true}) }, through: :employee_call_outs, source: :employee

  delegate :name, to: :user, allow_nil: true, prefix: true
  default_scope ->() {order("created_at DESC")}
  scope :incomplete, ->(time = Time.now - 20){where(filtered_at: nil).where("created_at < ?", time)}

  def filtered?
    filtered_at.present?
  end

  def self.create_for_call_out_shift(call_out_shift, user)
    create(user: user, call_out_shift: call_out_shift).tap do |call_out_list|
      call_out_shift.eligible_employees.each do |employee|
        call_out_list.employee_call_outs << EmployeeCallOut.new(employee: employee)
      end
      PipelineWorker.run_pipeline(call_out_list, call_out_shift)
    end
  end

end
