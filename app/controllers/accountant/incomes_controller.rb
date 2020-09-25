class Accountant::IncomesController < Manager::IncomesController
  include IncomeAction

  def index
    @incomes = Income.eager_load(user: :group)
                     .by_date
                     .incomes_by_group(current_user.group_id)
                     .page(params[:page]).per Settings.income.per_page
  end
end
