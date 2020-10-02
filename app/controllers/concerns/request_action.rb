module RequestAction
  extend ActiveSupport::Concern

  included do
    before_action :get_request, only: %i(review confirm rejected)
  end

  def review
    if @request.pending?
      @request.review!
      @request.update approver_id: current_user.id
      @messages = t "request.noti.updated"
    else
      flash[:danger] = t "request.noti.show_fail"
    end
    respond_to :js
  end

  def confirm
    if @request.approve?
      @request.update paider_id: current_user.id,
                        budget_id: params[:request][:budget_id]
      @request.confirm!
      @messages = t "request.noti.updated"
    else
      flash[:danger] = t "request.noti.show_fail"
    end
    respond_to :js
  end

  def rejected
    if @request.rejected?
      flash[:danger] = t "request.noti.show_fail"
    else
      @request.rejected!
      @request.update rejecter_id: current_user.id
      @messages = t "request.noti.updated"
    end
    respond_to :js
  end

  private

  def get_request
    @request = Request.find_by id: params[:id]
    return if @request

    flash[:danger] = t "request.noti.show_fail"
    redirect_to admin_requests_path
  end
end
