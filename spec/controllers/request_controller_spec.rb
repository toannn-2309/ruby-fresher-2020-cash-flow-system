require "rails_helper"
require "cancan/matchers"
include RSpecTestHelper

RSpec.describe RequestsController, type: :controller do
  let(:group) {FactoryBot.create :group}
  let(:user) {FactoryBot.create :user, group_id: group.id, role: "staff"}
  let(:budget) {FactoryBot.create :budget}
  let(:request_obj) {FactoryBot.create :request, user_id: user.id, budget_id: budget.id}
  let(:valid_params) do
    FactoryBot.attributes_for(:request, user_id: user.id, budget_id: budget.id,
      request_detail_attributes: [FactoryBot.attributes_for(:request_detail)]
    )
  end
  let(:invalid_params) {FactoryBot.attributes_for :request, title: nil}
  let(:r1) {FactoryBot.create :request, user_id: user.id, created_at: "2020-10-01 17:00:00"}
  let(:r2) {FactoryBot.create :request, user_id: user.id, created_at: "2020-10-02 17:00:00"}
  
  before {login user}
  
  describe "GET #index" do
    before {get :index, params: {page: 1}}

    it "renders the index template" do
      expect(response).to render_template :index
    end

    it "show status 200" do
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    context "when valid param" do
      before {get :show, params: {id: request_obj.id}}

      it "valid request" do
        expect(assigns(:request).id).to eq request_obj.id
      end

      it "render show template" do
        expect(response).to render_template :show
      end
    end

    context "when invalid param" do
      before {get :show, params: {id: "test"}}

      it "invalid request" do
        expect(assigns(:request)).to eq nil
      end

      it "render show template" do
        expect(response).to redirect_to requests_path
      end
    end
  end

  describe "GET #new" do
    before {get :new}

    it "assigns a new Request to @request" do
      expect(assigns(:request)).to be_a_new Request  
    end

    it "render the new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with invalid attributes" do
      before do
        post :create, params: {request: invalid_params}
      end

      it "create a new subject fail" do
        expect{post :create, params: {request: invalid_params}}.to change(Request, :count).by(0)
      end

      it "render template subject" do
        expect(response).to render_template :new
      end
    end

    context "with valid attributes" do
      before do
        post :create, params: {request: valid_params}
      end

      it "create a new subject success" do
        expect {post :create, params: {request: valid_params}}.to change(Request, :count).by(1)
      end

      it "should redirect to trainers_subjects_path" do
        expect(response).to redirect_to requests_path
      end
    end
  end

  describe "GET #edit" do
    context "when valid param" do
      before {get :edit, params: {id: r1.id}}

      it "should have a valid request" do
        expect(assigns(:request).id).to eq r1.id
      end

      it "should render edit template" do
        expect(response).to render_template :edit
      end
    end

    context "when invalid param" do
      before {get :edit, params: {id: "test"}}

      it "should have a invalid request" do
        expect(assigns(:request)).to eq nil
      end

      it "should redirect to requests_path" do
        expect(response).to redirect_to requests_path
      end
    end
  end

  describe "PATCH #update" do
    context "when valid params" do
      before {patch :update, params: {id: request_obj.id, request: {title: "title update"}}}

      it "should correct title" do
        expect(assigns(:request).title).to eq "title update"
      end

      it "should redirect requests_path" do
        expect(response).to redirect_to requests_path
      end
    end

    context "when invalid params" do
      before { patch :update, params: {id: request_obj.id, request: invalid_params} }

      it "should a invalid request" do
        expect(assigns(:request).invalid?).to eq true
      end

      it "should render edit template" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    context "when valid params" do
      before { delete :destroy, params: {id: request_obj.id} }

      it "destroy request" do
        expect(assigns(:request).destroyed?).to eq true
      end

      it "should redirect to requests_path" do
        expect(response).to redirect_to requests_path
      end
    end

    context "when invalid params" do
      before {delete :destroy, params: {id: "test"}}

      it "should a invalid request" do
        expect{subject}.to change(Request, :count).by 0
      end

      it "should redirect to requests_path" do
        expect(response).to redirect_to requests_path
      end
    end

    context "when a failure request destroy" do
      before do
        allow_any_instance_of(Request).to receive(:destroy).and_return false
        delete :destroy, params: {id: request_obj.id}
      end

      it "flash error message" do
        expect(flash[:danger]).to eq I18n.t("request.noti.destroy_fail")
      end

      it "should redirect to requests_path" do
        expect(response).to redirect_to requests_path
      end
    end
  end
end
