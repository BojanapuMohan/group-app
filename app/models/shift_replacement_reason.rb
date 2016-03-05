class ShiftReplacementReason < ActiveRecord::Base
  has_many :employee_shifts

  def self.vacation
    ShiftReplacementReason.where(reason: "Vacation", abreviation: "V").first_or_create
  end

  def self.self_cancelled
    ShiftReplacementReason.where(reason: "Self Cancelled", abreviation: "SC").first_or_create
  end

  def to_s
    reason
  end
end
