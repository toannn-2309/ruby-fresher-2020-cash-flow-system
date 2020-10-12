class ManagerAbility
  include CanCan::Ability

  def initialize user
    return if user.blank? || !user.manager?

    can :manage, [Request, Income], user_id: user.id
    can :manage, User, user_id: user.id
  end
end
