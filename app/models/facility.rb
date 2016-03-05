class Facility < ActiveRecord::Base
  include CanEnable

  has_and_belongs_to_many :availabilities
  has_many :shifts
  has_and_belongs_to_many :users
  
  default_scope -> {enabled.order('name')}

  def to_s
    name
  end

end
