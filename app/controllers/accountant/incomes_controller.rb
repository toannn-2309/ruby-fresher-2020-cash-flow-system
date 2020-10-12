class Accountant::IncomesController < Manager::IncomesController
  include IncomeAction

  authorize_resource

  def index
    @incomes = Income.eager_load(:budget, :user, :confirmer, :rejecter)
                     .by_date
                     .incomes_by_group(current_user.group_id)
                     .page(params[:page]).per Settings.income.per_page
  end

  private

  def current_ability
    @current_ability ||= AccountantAbility.new current_user
  end
end
