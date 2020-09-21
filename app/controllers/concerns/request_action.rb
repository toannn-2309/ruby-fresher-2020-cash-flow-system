module RequestAction
  extend ActiveSupport::Concern

  included do
    before_action :get_request, only: %i(review confirm rejected)
  end

  def review
    @request.review!
    @request.update approver: current_user.name
    redirect_to admin_requests_path
  end

  def confirm
    @request.confirm!
    redirect_to admin_requests_path
  end

  def rejected
    @request.rejected!
    @request.update rejecter: current_user.name
    redirect_to admin_requests_path
  end

  private

  def get_request
    @request = Request.find_by id: params[:id]
    return if @request

    flash[:danger] = t "request.noti.show_fail"
    redirect_to admin_requests_path
  end
end
