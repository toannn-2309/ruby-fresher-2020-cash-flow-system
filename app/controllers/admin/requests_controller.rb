class Admin::RequestsController < Admin::BaseController
  include RequestAction

  before_action :get_request, except: %i(index new create)

  def index
    @requests = Request.by_date
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
    if @request.destroy
      flash[:success] = t "request.noti.destroy"
    else
      flash[:danger] = t "request.noti.destroy_fail"
    end
    redirect_to admin_requests_path
  end

  private

  def request_params
    params.require(:request).permit Request::PARAMS
  end
end
