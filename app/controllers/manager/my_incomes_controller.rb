class Manager::MyIncomesController < Manager::IncomesController
  def index
    @my_incomes = current_user.incomes.by_date
                              .page(params[:page]).per Settings.request.per_page
  end
end
