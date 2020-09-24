class Accountant::RequestsController < RequestsController
  include RequestAction

  def index
    @requests = Request.eager_load(user: :group)
                       .by_date_and_state_asc
                       .requests_by_group(current_user.group_id)
                       .status_not_pending
                       .page(params[:page]).per Settings.request.per_page
  end
end
