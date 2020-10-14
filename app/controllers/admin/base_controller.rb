class Admin::BaseController < ApplicationController
  layout "admin/admin_application"
  before_action :count_table, only: :index
  authorize_resource

  def index
    @budgets = Budget.all
    @paid_requests = Request.includes(:budget, :user, :paider)
                            .by_updated.by_request_paid
                            .limit(Settings.limit_request)
    @confirm_incomes = Income.includes(:budget, :user, :confirmer)
                             .by_updated.by_request_confirm
                             .limit(Settings.limit_request)
    @count_request_chart = Request.group(:aasm_state).size
  end

  def range
    if params[:last_day].to_date < params[:first_day].to_date
      @messages = t "admin.chart.noti_day"
    else
      @count_range = Request.group(:aasm_state)
                            .group_by_day(:updated_at, range:
        params[:first_day].to_date..params[:last_day].to_date).size
    end
  end

  private

  rescue_from CanCan::AccessDenied do
    flash[:warning] = t "noti.no_access"
    redirect_to home_path
  end

  def current_ability
    @current_ability ||= AdminAbility.new current_user
  end

  def count_table
    @count_user = User.all.size
    @count_request = Request.all.size
    @count_income = Income.all.size
  end
end
