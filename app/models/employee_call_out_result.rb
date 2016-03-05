class EmployeeCallOutResult < ActiveRecord::Base
  has_many :employee_call_outs

  def self.accepted_results
    @@accepted_results ||= ['Accepted - Full Block Coverage', 'Accepted - Partial Block Coverage'].map {|result|  EmployeeCallOutResult.where(result: result).first_or_create}
  end

  def self.declined_results
    @@declined_results ||= ['Declined'].map {|result|  EmployeeCallOutResult.where(result: result).first_or_create}
  end

  def self.no_answer_results
    @@no_answer_results ||= ["No Answer", "Left Voice-mail"].map {|result|  EmployeeCallOutResult.where(result: result).first_or_create}
  end

  def to_s
    result
  end

  def block_coverage
    result.match(/Partial/) ? "Partial" : "Full"
  end
end
