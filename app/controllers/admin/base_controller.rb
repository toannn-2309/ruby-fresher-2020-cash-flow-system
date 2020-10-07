class Admin::BaseController < ApplicationController
  before_action :check_admin
  layout "admin/admin_application"

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

  def check_admin
    return if current_user.admin?

    redirect_to home_path
    flash[:danger] = t "admin.noti.not_admin"
  end
end
