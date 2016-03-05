class DayOfWeekAvailability < ActiveRecord::Base
  has_and_belongs_to_many :availabilities, join_table: 'availability_day_of_week_availability'

  scope :morning, -> {where(time_of_day: 'Morning')}
  scope :evening, -> {where(time_of_day: 'Evening')}
  scope :night, -> {where(time_of_day: 'Night')}

  def self.week_days
    ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
  end

  def self.times_of_day
    ["Morning","Evening","Night"]
  end

  def self.for_wday_and_time(wday, time_of_day)
    where(day_of_week: wday, time_of_day: time_of_day).first_or_create
  end

  def week_day
    return nil if day_of_week.blank?
    self.class.week_days[day_of_week]
  end

  def self.setup
    week_days.each_with_index do |day, wday|
      DayOfWeekAvailability.times_of_day.each do |time_of_day|
        DayOfWeekAvailability.where(day_of_week: wday, time_of_day: time_of_day).first_or_create
      end
    end
  end

end
