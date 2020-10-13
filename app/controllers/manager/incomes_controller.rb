class Manager::IncomesController < ApplicationController
  before_action :get_income, except: %i(index new create)
  before_action :get_budget, only: :index
  before_action :income_not_pending, only: :edit
  load_and_authorize_resource

  def index
    @incomes = Income.eager_load(Income::INCOME_LOAD).by_date
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

  rescue_from CanCan::AccessDenied do
    flash[:warning] = t "noti.no_access"
    redirect_to home_path
  end

  def income_params
    params.require(:income).permit Income::INCOME_PARAMS
  end

  def get_income
    @income = current_user.incomes.find_by id: params[:id]
    return if @income

    flash[:danger] = t "income.noti.show_fail"
    redirect_to manager_incomes_path
  end

  def current_ability
    @current_ability ||= ManagerAbility.new current_user
  end
end
