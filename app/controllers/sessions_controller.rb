class SessionsController < ApplicationController
  layout "root", only: %i(new create)

  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user&.authenticate params[:session][:password]
      log_in user
      flash[:success] = t "user.noti.login"
      redirect_to home_url
    else
      flash.now[:danger] = t "user.noti.login_fail"
      render :new
    end
  end

  def destroy
    flash[:success] = t "user.noti.logout"
    log_out
    redirect_to root_url
  end
end
