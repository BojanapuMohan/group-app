class Ability
  include CanCan::Ability

  def initialize(user)
    #alias_action :edit, :to => :read

    if user.has_role?(:administrator)
      can :manage, :all
      cannot [:enable, :disable], User, id: user.id
      cannot :enable, User, enabled?: true
      cannot :disable, User, disabled?: true
    end

    if user.has_role? :scheduler
      can :create_note, Employee
    end

    if user.has_role? :coordinator
      can :read, [Shift, EmployeesRole]  
      can [:read, :create_note], Employee 
    end

    can [:read, :update], User, id: user.id
    can :read, Shift
    can :read, Facility, :id => user.facility_ids
    can :manage, CallOutShift

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
