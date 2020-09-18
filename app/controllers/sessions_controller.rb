class SessionsController < ApplicationController
  before_action :find_email, only: :create
  layout "root", only: %i(new create)

  def new; end

  def create
    if @user&.authenticate params[:session][:password]
      log_in @user
      flash[:success] = t "user.noti.login"
      check_remember params[:session][:remember_me], @user
      redirect_back_or home_path
    else
      flash.now[:danger] = t "user.noti.login_fail"
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end

  private

  def find_email
    @user = User.find_by email: params[:session][:email].downcase
  end

  def check_remember remember_me, user
    remember_me == Settings.session.remember ? remember(user) : forget(user)
  end
end
