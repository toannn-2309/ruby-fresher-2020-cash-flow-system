module IncomeAction
  extend ActiveSupport::Concern

  included do
    before_action :get_income, only: %i(confirm rejected)
  end

  def confirm
    @income.confirm!
    @income.update confirmer: current_user.name
    redirect_to admin_incomes_path
  end

  def rejected
    @income.rejected!
    @income.update rejecter: current_user.name
    redirect_to admin_incomes_path
  end

  private

  def get_income
    @income = Income.find_by id: params[:id]
    return if @income

    flash[:danger] = t "income.noti.show_fail"
    redirect_to admin_incomes_path
  end
end
