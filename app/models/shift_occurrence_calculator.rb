class ShiftOccurrenceCalculator

  attr_accessor :occurrences

  def initialize(occurrences)
    @occurrences = Array(occurrences).sort.map {|occurrence| ShiftOccurrenceCalculatorItem.new(occurrence)}
  end

  def durations_per_day
    results = Hash.new(0)
    occurrences.each do |occurence|
      results.merge!(occurence.duration_per_24_hour_period) { |key, v1, v2| v1 + v2 }
    end
    results
  end

  def durations_per_week
    Hash[durations_per_day.group_by {|date, hours| date.beginning_of_week}.map {|week, days| [week, days.map(&:last).sum]}]
  end

  def dates
    (occurrences.map(&:date) + occurrences.map(&:end_date)).uniq.sort
  end

  def <<(new_occurrence)
    occurrences << ShiftOccurrenceCalculatorItem.new(new_occurrence)
    occurrences.sort!
  end

  def +(new_occurrences)
    Array(new_occurrences).each {|new_occurrence| self << new_occurrence}
  end

  def breaks_between_shifts
    results = Hash.new(24)
    occurrences.each_with_index do |occurrence, index|
      next if index == 0
      results.merge!({occurrence.date => occurrence.break_since(occurrences[index - 1])}) { |key, v1, v2| [v1, v2].max }
    end
    results
  end

  def shifts_between(start_date, end_date)
    occurrences.select {|occurrence| occurrence.date.between?(start_date, end_date)}
  end

  def shift_on(date)
    shifts_between(date, date).first
  end
end

class ShiftOccurrenceCalculatorItem < SimpleDelegator

  attr_accessor :occurrence

  def initialize(occurrence)
    super
    @occurrence = occurrence
  end

  def duration_per_24_hour_period
    if occurrence.end_time <= occurrence.date_time.end_of_day + 1
      {occurrence.date => occurrence.duration}
    else
      {
       occurrence.date => ((occurrence.date_time.end_of_day - occurrence.date_time)/60/60).round(1),
       occurrence.end_date => ((occurrence.end_time - occurrence.date_time.end_of_day)/60/60).round(1)
      }
    end
  end
end
