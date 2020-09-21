module IncomeAction
  extend ActiveSupport::Concern

  included do
    before_action :get_income, only: %i(confirm rejected)
  end

  def confirm
    if @income.pending?
      @income.update confirmer_id: current_user.id,
                     budget_id: params[:income][:budget_id]
      @income.confirm!
    else
      flash[:danger] = t "income.noti.show_fail"
    end
    redirect_to admin_incomes_path
  end

  def rejected
    if @income.rejected?
      flash[:danger] = t "income.noti.show_fail"
    else
      @income.rejected!
      @income.update rejecter_id: current_user.id
    end
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
