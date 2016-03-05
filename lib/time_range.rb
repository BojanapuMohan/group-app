class TimeRange
  attr_accessor :start_time, :end_time
  def initialize(start_time, end_time)
    @start_time = start_time
    @end_time = end_time
  end

  def overlaps?(other)
    ( start_time <= other.end_time && other.start_time <= end_time )
  end
end
