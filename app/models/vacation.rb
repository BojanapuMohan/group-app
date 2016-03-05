class Vacation < ActiveRecord::Base
  belongs_to :employee
  belongs_to :shift
  has_one :facility, through: :shift

  scope :between, ->(start_date, end_date) {where("vacations.start_date <= ? and vacations.end_date >= ?", end_date, start_date)} #TODO check this
  scope :on, ->(date) {between(date, date)}

  def read_only?
    true
  end
end
