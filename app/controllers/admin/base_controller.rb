class Admin::BaseController < ApplicationController
  before_action :logged_in_user
  before_action :check_admin
  layout "admin/admin_application"

  def index
    @count_user = User.all.size
    @count_request = Request.all.size
  end

  private

  def check_admin
    return if current_user.admin?

    redirect_to home_path
    flash[:alert] = t "admin.noti.not_admin"
  end
end
