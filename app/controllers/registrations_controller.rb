class RegistrationsController < Devise::RegistrationsController
  layout "application"

  def update
    if current_user.valid_password? params[:user][:password]
      resource.errors[:password] << t("user.noti.pw_update_fail")
      render :edit
    else
      super
    end
  end
end
