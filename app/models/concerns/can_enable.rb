module CanEnable
  extend ActiveSupport::Concern

  included do
    scope :enabled, ->{where(enabled: true)}
  end

  def enable!
    update_attribute(:enabled, true)
  end

  def disable!
    update_attribute(:enabled, false)
  end

  def disabled?
    !enabled?
  end
end

