module RequestAction
  extend ActiveSupport::Concern

  included do
    before_action :get_request, only: %i(review confirm rejected)
  end

  def review
    if @request.pending?
      @request.review!
      @request.update approver_id: current_user.id
    else
      flash[:danger] = t "request.noti.show_fail"
    end
    return redirect_to admin_requests_path if current_user.admin?

    redirect_to manager_requests_path
  end

  def confirm
    if @request.approve?
      if @request.update paider_id: current_user.id,
                      budget_id: params[:request][:budget_id]
        @request.confirm!
      else
        flash[:danger] = t "request.noti.updated_fail"
      end
    else
      flash[:danger] = t "request.noti.show_fail"
    end
    return redirect_to admin_requests_path if current_user.admin?

    redirect_to accountant_requests_path
  end

  def rejected
    if @request.rejected?
      flash[:danger] = t "request.noti.show_fail"
    else
      @request.rejected!
      @request.update rejecter_id: current_user.id
    end
    return redirect_to admin_requests_path if current_user.admin?

    return redirect_to manager_requests_path if current_user.manager?

    redirect_to accountant_requests_path
  end

  private

  def get_request
    @request = Request.find_by id: params[:id]
    return if @request

    flash[:danger] = t "request.noti.show_fail"
    redirect_to admin_requests_path
  end
end
