class Admin::SessionsController < Devise::SessionsController
  def create
    @user = User.find_by(email: params[:user][:email])
    if @user&.admin?
      super
    else
      flash[:danger] = t "admin.noti.email_not_login"
      redirect_to admin_login_path
    end
  end

  def after_sign_in_path_for _resource
    admin_root_path
  end

  def after_sign_out_path_for _resource
    admin_login_path
  end
end
