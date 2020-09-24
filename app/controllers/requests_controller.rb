class RequestsController < ApplicationController
  before_action :logged_in_user
  before_action :get_request, except: %i(index new create)
  before_action :get_budget, only: :index
  before_action :request_not_pending, only: :edit

  def index
    @requests = current_user.requests.by_date
                            .page(params[:page]).per Settings.request.per_page
  end

  def show; end

  def new
    @request = Request.new
  end

  def create
    @request = current_user.requests.build request_params
    if @request.save
      flash[:success] = t "request.noti.created"
      redirect_to requests_path
    else
      flash.now[:danger] = t "request.noti.created_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @request.update request_params
      flash[:success] = t "request.noti.updated"
      redirect_to requests_path
    else
      flash.now[:danger] = t "request.noti.updated_fail"
      render :edit
    end
  end

  def destroy
    if @request.destroy
      flash[:success] = t "request.noti.destroy"
    else
      flash[:danger] = t "request.noti.destroy_fail"
    end

    return redirect_to manager_requests_path if current_user.manager?

    redirect_to requests_path
  end

  private

  def get_request
    @request = current_user.requests.find_by id: params[:id]
    return if @request

    flash[:danger] = t "request.noti.show_fail"
    redirect_to requests_path
  end

  def request_params
    params.require(:request).permit Request::REQUESTS_PARAMS
  end
end
