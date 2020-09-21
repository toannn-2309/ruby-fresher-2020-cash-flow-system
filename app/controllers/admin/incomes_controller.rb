class Admin::IncomesController < Admin::BaseController
  include IncomeAction

  before_action :get_income, except: %i(index new create)

  def index
    @incomes = Income.by_date
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
      redirect_to admin_incomes_path
    else
      flash.now[:danger] = t "income.noti.created_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @income.update income_params
      flash[:success] = t "income.noti.updated"
      redirect_to admin_incomes_path
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
    redirect_to admin_incomes_path
  end

  private

  def income_params
    params.require(:income).permit Income::INCOME_PARAMS
  end
end
