require "rails_helper"
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
  let!(:r1) {FactoryBot.create :request, user_id: admin.id, created_at: "2020-10-01 17:00:00"}
  let!(:r2) {FactoryBot.create :request, user_id: admin.id, created_at: "2020-10-02 17:00:00"}

  before do
    log_in admin
    admin?
  end

  describe "GET #index" do
    before {get :index, params: {page: 1}}

    it "renders the index template" do
      expect(response).to render_template :index
    end

    it "assigns @requests" do
      expect(assigns(:requests).pluck(:id)).to eq [r2.id, r1.id]
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
      before { delete :destroy, params: {id: request_obj.id} }

      it "destroy request" do
        expect(assigns(:request).destroyed?).to eq true
      end

      it "should redirect to admin_requests_path" do
        expect(response).to redirect_to admin_requests_path
      end
    end

    context "when invalid params" do
      before {delete :destroy, params: {id: "test"}}

      it "should a invalid request" do
        expect{subject}.to change(Request, :count).by 0
      end

      it "should redirect to admin_requests_path" do
        expect(response).to redirect_to admin_requests_path
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

      it "should redirect to admin_requests_path" do
        expect(response).to redirect_to admin_requests_path
      end
    end
  end

  describe "PATCH #review" do
    context "when valid params" do
      before {patch :review, params: {id: request_obj.id, request: {aasm_state: "approve"}}}
      it "should correct aasm_state" do
        expect(assigns(:request).aasm_state).to eq "approve"
      end

      it "should redirect admin_requests_path" do
        expect(response).to redirect_to admin_requests_path
      end
    end

    context "when invalid params" do
      let(:r3) {FactoryBot.create :request, user_id: user.id, aasm_state: "approve"}
      before {patch :review, params: {id: r3.id, request: {aasm_state: "approve"}}}
      it "should a invalid request" do
        expect(assigns(:request).pending?).to eq false
      end

      it "should render edit template" do
        expect(response).to redirect_to admin_requests_path
      end
    end
  end

  describe "PATCH #confirm" do
    let(:r4) {FactoryBot.create :request, user_id: admin.id, aasm_state: "approve", budget_id: budget.id, paider_id: admin.id}
    context "when valid params" do
      before {patch :confirm, params: {id: r4.id, request: {aasm_state: "paid", budget_id: budget.id, paider_id: admin.id}}}
      it "should correct aasm_state" do
        expect(assigns(:request).aasm_state).to eq "paid"
      end

      it "should redirect admin_requests_path" do
        expect(response).to redirect_to admin_requests_path
      end
    end

    context "when valid params and update fail" do
      before {patch :confirm, params: {id: r4.id, request: {aasm_state: "paid"}}}
      it "should correct aasm_state" do
        expect(assigns(:request).paid?).to eq false
      end

      it "should redirect admin_requests_path" do
        expect(response).to redirect_to admin_requests_path
      end
    end

    context "when invalid params" do
      before {patch :confirm, params: {id: request_obj.id, request: {aasm_state: "paid"}}}
      it "should a invalid request" do
        expect(assigns(:request).paid?).to eq false
      end

      it "should render edit template" do
        expect(response).to redirect_to admin_requests_path
      end
    end
  end

  describe "PATCH #rejected" do
    context "when valid params" do
      before {patch :rejected, params: {id: request_obj.id, request: {aasm_state: "rejected"}}}
      it "should correct aasm_state" do
        expect(assigns(:request).aasm_state).to eq "rejected"
      end

      it "should redirect admin_requests_path" do
        expect(response).to redirect_to admin_requests_path
      end
    end

    context "when invalid params" do
      let(:r5) {FactoryBot.create :request, user_id: user.id, aasm_state: "rejected"}
      before {patch :rejected, params: {id: r5.id, request: {aasm_state: "rejected"}}}
      it "should a invalid request" do
        expect(assigns(:request).rejected?).to eq true
      end

      it "should render edit template" do
        expect(response).to redirect_to admin_requests_path
      end
    end
  end

end
