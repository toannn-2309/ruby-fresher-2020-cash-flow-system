require "rails_helper"
require "cancan/matchers"
include RSpecTestHelper

RSpec.describe Admin::RequestsController, type: :controller do
  let(:group) {FactoryBot.create :group}
  let(:admin) {FactoryBot.create :user, role: "admin"}
  let(:user) {FactoryBot.create :user, group_id: group.id}
  let(:budget) {FactoryBot.create :budget}
  let(:request_obj) {FactoryBot.create :request, user_id: user.id, budget_id: budget.id}
  let(:valid_params) do
    FactoryBot.attributes_for(:request, user_id: user.id, budget_id: budget.id,
      request_detail_attributes: [FactoryBot.attributes_for(:request_detail)]
    )
  end
  let(:invalid_params) {FactoryBot.attributes_for :request, title: nil}
  let(:r1) {FactoryBot.create :request, user_id: admin.id, created_at: "2020-10-01 17:00:00"}
  let(:r2) {FactoryBot.create :request, user_id: admin.id, created_at: "2020-10-02 17:00:00"}

  before {login admin}

  describe "GET #index" do
    before {get :index, xhr: true, params: {page: 1}}

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
        expect(response).to redirect_to admin_requests_path
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
        expect(response).to redirect_to admin_requests_path
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

      it "should redirect to admin_posts_path" do
        expect(response).to redirect_to admin_requests_path
      end
    end
  end

  describe "PATCH #update" do
    context "when valid params" do
      before {patch :update, params: {id: request_obj.id, request: {title: "title update"}}}

      it "should correct title" do
        expect(assigns(:request).title).to eq "title update"
      end

      it "should redirect admin_requests_path" do
        expect(response).to redirect_to admin_requests_path
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
      before {delete :destroy, xhr: true, params: {id: request_obj.id}}

      it "destroy request" do
        expect(assigns(:request).destroyed?).to eq true
      end

      it "show status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when invalid params" do
      before {delete :destroy, xhr: true, params: {id: "test"}}

      it "should a invalid request" do
        expect{subject}.to change(Request, :count).by 0
      end

      it "should redirect to admin_requests_path" do
        expect(response).to redirect_to admin_requests_path
      end

      it "show status 200" do
        expect(response).to have_http_status(200)
      end
    end
  end

  describe "PATCH #review" do
    context "when valid params" do
      before {patch :review, xhr: true, params: {id: request_obj.id, request: {aasm_state: "approve"}}}
      it "should correct aasm_state" do
        expect(assigns(:request).aasm_state).to eq "approve"
      end

      it "show status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when invalid params" do
      let(:r3) {FactoryBot.create :request, user_id: user.id, aasm_state: "approve"}
      before {patch :review, xhr: true, params: {id: r3.id, request: {aasm_state: "approve"}}}
      it "should a invalid request" do
        expect(assigns(:request).pending?).to eq false
      end

      it "show status 200" do
        expect(response).to have_http_status(200)
      end

      it "show flash messeage" do
        expect(flash[:danger]).to match(I18n.t("request.noti.show_fail"))
      end
    end
  end

  describe "PATCH #confirm" do
    let(:r4) {FactoryBot.create :request, user_id: admin.id, aasm_state: "approve", budget_id: budget.id, paider_id: admin.id}
    context "when valid params" do
      before {patch :confirm, xhr: true, params: {id: r4.id, request: {aasm_state: "paid", budget_id: budget.id, paider_id: admin.id}}}
      it "should correct aasm_state" do
        expect(assigns(:request).aasm_state).to eq "paid"
      end

      it "show status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when invalid params and update fail" do
      before {patch :confirm, xhr: true, params: {id: r4.id, request: {aasm_state: "paid"}}}
      it "should correct aasm_state" do
        expect(assigns(:request).paid?).to eq false
      end

      it "show status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when invalid params" do
      let(:r6) {FactoryBot.create :request, user_id: admin.id, aasm_state: "rejected", budget_id: budget.id, paider_id: admin.id}
      before {patch :confirm, xhr: true, params: {id: r6.id, request: {aasm_state: "paid"}}}
      it "should correct aasm_state" do
        expect(assigns(:request).paid?).to eq false
      end

      it "show flash messeage" do
        expect(flash[:danger]).to match(I18n.t("request.noti.show_fail"))
      end
    end
  end

  describe "PATCH #rejected" do
    context "when valid params" do
      before {patch :rejected, xhr: true, params: {id: request_obj.id, request: {aasm_state: "rejected"}}}
      it "should correct aasm_state" do
        expect(assigns(:request).aasm_state).to eq "rejected"
      end

      it "show status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when invalid params" do
      let(:r5) {FactoryBot.create :request, user_id: user.id, aasm_state: "rejected"}
      before {patch :rejected, xhr: true, params: {id: r5.id, request: {aasm_state: "rejected"}}}
      it "should a invalid request" do
        expect(assigns(:request).rejected?).to eq true
      end

      it "show flash messeage" do
        expect(flash[:danger]).to match(I18n.t("request.noti.show_fail"))
      end
    end
  end

# Check for Abilities
  describe "check for abilities" do
    context "Admin can do" do
      it {should be_able_to :create, Request.new}
      it {should be_able_to :update, Request.new}
    end
  end
end
