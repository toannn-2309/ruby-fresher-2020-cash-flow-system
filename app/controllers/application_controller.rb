class ApplicationController < ActionController::Base
  include SessionsHelper

  before_action :set_locale

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "user.noti.need_login"
    redirect_to root_path
  end

  def get_group
    @groups_view = Group.pluck(:name, :id).to_h
  end

  def get_budget
    @budget_view = Budget.pluck(:name, :id).to_h
  end

  # Check request not pending
  def request_not_pending
    return if @request.pending?

    flash[:danger] = t "request.noti.no_edit"
    redirect_to requests_path
  end
end
