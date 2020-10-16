class Admin::IncomesController < Admin::BaseController
  include IncomeAction

  before_action :get_income, except: %i(index new create)
  before_action :get_budget, only: :index
  before_action :income_not_pending, only: :edit

  def index
    # @incomes_search = Income.search(params[:query], fields: [:title],
    #   match: :word_start, highlight: {tag: "<mark>"},
    #   page: params[:page], per_page: Settings.income.per_page,
    #   includes: [Income::INCOME_LOAD])
    @incomes = Income.eager_load(Income::INCOME_LOAD)
                     .by_date
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
    if @income.update income_params_edit
      flash[:success] = t "income.noti.updated"
      redirect_to admin_incomes_path
    else
      flash.now[:danger] = t "income.noti.updated_fail"
      render :edit
    end
  end

  def destroy
    @messages = t "request.noti.destroy" if @income.destroy
    respond_to do |format|
      format.html{redirect_to admin_incomes_path}
      format.js
    end
  end

  private

  def income_params
    params.require(:income).permit Income::INCOME_PARAMS
  end

  def income_params_edit
    params.require(:income).permit Income::INCOME_PARAMS_ADMIN_EDIT
  end
end
