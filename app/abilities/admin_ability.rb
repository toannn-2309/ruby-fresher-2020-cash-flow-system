class AdminAbility
  include CanCan::Ability

  def initialize user
    return if user.blank? || !user.admin?

    can :manage, :all
  end
end
