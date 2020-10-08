class Admin::RequestsController < Admin::BaseController
  include RequestAction

  before_action :get_request, except: %i(index new create)
  before_action :get_budget, only: :index
  before_action :request_not_pending, only: :edit

  def index
    @q = Request.ransack params[:q]
    @requests = @q.result(distinct: true)
                  .eager_load(Request::REQUEST_LOAD)
                  .by_date.page(params[:page]).per Settings.request.per_page
    respond_to :js, :html
  end

  def show; end

  def new
    @request = Request.new
    @request_details = @request.request_details.build
  end

  def create
    @request = current_user.requests.build request_params
    if @request.save
      flash[:success] = t "request.noti.created"
      redirect_to admin_requests_path
    else
      flash.now[:danger] = t "request.noti.created_fail"
      render :new
    end
  end

  def edit; end

  def update
    if @request.update request_params
      flash[:success] = t "request.noti.updated"
      redirect_to admin_requests_path
    else
      flash.now[:danger] = t "request.noti.updated_fail"
      render :edit
    end
  end

  def destroy
    @messages = t "request.noti.destroy" if @request.destroy
    respond_to do |format|
      format.html{redirect_to admin_requests_path}
      format.js
    end
  end

  private

  def request_params
    params.require(:request).permit Request::REQUESTS_PARAMS
  end
end
