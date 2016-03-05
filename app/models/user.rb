class User < ActiveRecord::Base
  rolify
  include CanEnable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :facilities

  delegate :name, :id, to: :role, prefix: true, allow_nil: true
  
  validates :facilities, :length => { :minimum => 1, :message => "User is not Administrator, Please select atleast one facility to be assigned."},:if => :should_validate_facility?


  def should_validate_facility?
    !has_role?(:administrator)
  end


  def active_for_authentication?
    super && enabled
  end

  def role_id=(role_id)
    self.role_ids = [role_id]
  end

  def role
    roles.first
  end

  def facility_names
    return ["All"] if has_role? :administrator
    facilities.map(&:name)
  end

end
