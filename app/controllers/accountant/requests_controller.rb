class Accountant::RequestsController < RequestsController
  include RequestAction

  def index
    @requests = Request.eager_load(:budget, :user, :paider, :approver,
                                   :rejecter).by_date
                       .requests_by_group(current_user.group_id)
                       .page(params[:page]).per Settings.request.per_page
  end
end
