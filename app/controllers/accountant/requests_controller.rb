class Accountant::RequestsController < RequestsController
  include RequestAction

  authorize_resource

  def index
    @requests = Request.eager_load(Request::REQUEST_LOAD).by_date
                       .requests_by_group(current_user.group_id)
                       .page(params[:page]).per Settings.request.per_page
  end

  private

  def current_ability
    @current_ability ||= AccountantAbility.new current_user
  end
end
