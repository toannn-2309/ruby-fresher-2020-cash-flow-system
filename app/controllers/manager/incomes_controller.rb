class Manager::IncomesController < ApplicationController
  before_action :check_manager, only: %i(new edit update create destroy)
  before_action :get_income, except: %i(index new create)
  before_action :get_budget, only: %i(index)
  before_action :income_not_pending, only: :edit

  def index
    @incomes = Income.eager_load(user: :group)
                     .by_date
                     .incomes_by_group(current_user.group_id)
                     .page(params[:page]).per Settings.income.per_page
  end

  def show; end

  def new
    @income = Income.new
  end

  def create
    @income = current_user.incomes.build income_params
    if @income.save
      flash[:success] = t "income.noti.created"
      redirect_to manager_incomes_path
    else
      flash.now[:danger] = t "income.noti.created_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @income.update income_params
      flash[:success] = t "income.noti.updated"
      redirect_to manager_incomes_path
    else
      flash.now[:danger] = t "income.noti.updated_fail"
      render :edit
    end
  end

  def destroy
    if @income.destroy
      flash[:success] = t "income.noti.destroy"
    else
      flash[:danger] = t "income.noti.destroy_fail"
    end
    redirect_to manager_incomes_path
  end

  private

  def income_params
    params.require(:income).permit Income::INCOME_PARAMS
  end

  def get_income
    @income = current_user.incomes.find_by id: params[:id]
    return if @income

    flash[:danger] = t "income.noti.show_fail"
    redirect_to manager_incomes_path
  end

  def income_not_pending
    return if @income.pending?

    flash[:danger] = t "income.noti.no_edit"
    redirect_to manager_incomes_path
  end

  def check_manager
    return if current_user.manager?

    flash[:danger] = t "income.noti.no_manager"
    redirect_to home_path
  end
end
