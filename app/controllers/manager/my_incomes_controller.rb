class Manager::MyIncomesController < Manager::IncomesController
  skip_load_and_authorize_resource

  def index
    @my_incomes = current_user.incomes.eager_load(:budget, :confirmer,
                                                  :rejecter).by_date
                              .page(params[:page]).per Settings.request.per_page
  end
end
