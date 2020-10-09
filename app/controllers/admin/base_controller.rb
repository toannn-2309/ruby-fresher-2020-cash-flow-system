class Admin::BaseController < ApplicationController
  layout "admin/admin_application"
  authorize_resource

  def index
    @count_user = User.all.size
    @count_request = Request.all.size
    @count_income = Income.all.size
    @budgets = Budget.all
    @paid_requests = Request.includes(:budget, :user, :paider)
                            .by_updated.by_request_paid
                            .limit(Settings.limit_request)
    @confirm_incomes = Income.includes(:budget, :user, :confirmer)
                             .by_updated.by_request_confirm
                             .limit(Settings.limit_request)
  end

  private

  rescue_from CanCan::AccessDenied do
    flash[:warning] = t "noti.no_access"
    redirect_to home_path
  end

  def current_ability
    @current_ability ||= AdminAbility.new current_user
  end
end
