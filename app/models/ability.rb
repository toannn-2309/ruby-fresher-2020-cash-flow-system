class Ability
  include CanCan::Ability

  def initialize user
    return if user.blank?

    can :manage, Request, user_id: user.id
    can :read, User, user_id: user.id
  end
end
