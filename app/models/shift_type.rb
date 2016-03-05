class ShiftType < ActiveRecord::Base

  def duration
    read_attribute(:duration) / 60.0
  end
end
