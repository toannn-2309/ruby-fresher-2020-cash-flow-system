class Admin::SessionsController < SessionsController
  before_action :find_email, only: :create
  layout "root", only: %i(new create)

  def new; end

  def create
    if @user&.admin?
      if @user.authenticate params[:session][:password]
        log_in @user
        flash[:success] = t "user.noti.login"
        redirect_to admin_root_path
      else
        flash.now[:danger] = "user.noti.login_fail"
        render :new
      end
    else
      flash.now[:danger] = t "admin.noti.email_not_login"
      render :new
    end
  end

  def destroy
    flash[:success] = t "user.noti.logout"
    log_out
    redirect_to admin_login_path
  end

  private

  def find_email
    @user = User.find_by email: params[:session][:email].downcase
  end
end
