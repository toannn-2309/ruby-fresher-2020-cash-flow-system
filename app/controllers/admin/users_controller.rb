class Admin::UsersController < Admin::BaseController
  before_action :get_group, only: %i(new create edit show)
  before_action :get_user, except: %i(index new create)

  def index
    @users = User.not_admin.by_date
                 .by_role(params[:role])
                 .filter_by_name_or_email(params[:name])
                 .by_group(params[:group_id])
                 .page(params[:page]).per Settings.user.per_page
  end

  def show; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "user.noti.sigup"
      redirect_to admin_users_path
    else
      flash.now[:danger] = t "user.noti.sigup_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "user.noti.update"
      redirect_to admin_users_path
    else
      flash.now[:danger] = t "user.noti.update_fail"
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user.noti.destroy"
    else
      flash[:danger] = t "user.noti.destroy_fail"
    end
    redirect_to admin_users_path
  end

  private

  def get_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "user.noti.show_fail"
    redirect_to admin_users_path
  end

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end
end
