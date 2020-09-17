class UsersController < ApplicationController
  before_action :get_user, only: :show
  before_action :get_group, only: %i(new create)
  layout "root", only: %i(new create)

  def new
    @user = User.new
  end

  def show; end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t "user.noti.sigup"
      redirect_to root_url
    else
      flash.now[:danger] = t "user.noti.sigup_fail"
      render :new
    end
  end

  private

  def get_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "user.noti.show_fail"
    redirect_to root_url
  end

  def get_group
    @groups_view = Group.pluck(:name, :id).to_h
  end

  def user_params
    params.require(:user).permit User::USERS_PARAMS
  end
end
