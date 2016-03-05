class ShiftOccurrenceCollection
  attr_accessor :shifts, :start_date, :end_date
  def initialize(shifts, start_date, end_date)
    @shifts = shifts
    @start_date = start_date
    @end_date = end_date
  end

  def occurrences
    @occurrences ||= shifts.map {|shift| shift.occurrences(start_date, end_date)}.flatten
  end

  def find_by_shift_and_date(shift, date)
     occurrences.detect( -> {NullShiftOccurrence.new} ) {|occurence| occurence.id == shift.id && occurence.date == date}
  end
end
