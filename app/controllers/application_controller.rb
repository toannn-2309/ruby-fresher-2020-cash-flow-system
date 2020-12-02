class ApplicationController < ActionController::Base
  before_action :set_locale, :authenticate_user!, :load_noti

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    added_attrs = [:name, :group_id]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end

  def after_sign_in_path_for _resource
    home_path
  end

  def after_sign_out_path_for _resource
    new_user_session_path
  end

  private

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def get_group
    @groups_view = Group.pluck(:name, :id).to_h
  end

  def get_budget
    @budget_view = Budget.pluck(:name, :id).to_h
  end

  def load_noti
    @notifications = current_user.notifications if current_user.present?
  end

  # Check request not pending
  def request_not_pending
    return if @request.pending?

    flash[:danger] = t "request.noti.no_edit"
    return redirect_to admin_requests_path if current_user.admin?

    redirect_to requests_path
  end

  # Check income not pending
  def income_not_pending
    return if @income.pending?

    flash[:danger] = t "income.noti.no_edit"
    return redirect_to admin_incomes_path if current_user.admin?

    redirect_to manager_incomes_path
  end
end
