class RegistrationsController < Devise::RegistrationsController
  layout "application", only: %i(edit update)
  before_action :check_provider, only: %i(edit update)

  def edit
    super
  end

  def update
    if current_user.valid_password? params[:user][:password]
      resource.errors[:password] << t("user.noti.pw_update_fail")
      render :edit
    else
      super
    end
  end

  protected

  def after_update_path_for _resource
    flash[:notice] = t "user.noti.update"
    return admin_root_path if current_user.admin?

    home_path
  end

  def check_provider
    return unless current_user.provider == "facebook"

    flash[:danger] = t "user.noti.not_edit"
    redirect_to home_path
  end
end
