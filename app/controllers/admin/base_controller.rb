class Admin::BaseController < ApplicationController
  before_action :check_admin
  layout "admin/admin_application"

  def index
    @count_user = User.all.size
    @count_request = Request.all.size
    @count_income = Income.all.size
    @budgets = Budget.all
  end

  private

  def check_admin
    return if current_user.admin?

    redirect_to home_path
    flash[:danger] = t "admin.noti.not_admin"
  end
end
