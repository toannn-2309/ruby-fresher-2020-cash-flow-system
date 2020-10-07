require "rails_helper"
include RSpecTestHelper

RSpec.describe Admin::IncomesController, type: :controller do
  let(:group) {FactoryBot.create :group}
  let(:admin) {FactoryBot.create :user, role: "admin"}
  let(:user) {FactoryBot.create :user, group_id: group.id}
  let(:budget) {FactoryBot.create :budget}
  let(:income) {FactoryBot.create :income, user_id: user.id, budget_id: budget.id}
  let(:valid_params) {FactoryBot.attributes_for :income, user_id: user.id, budget_id: budget.id}
  let(:invalid_params) {FactoryBot.attributes_for :income, title: nil}
  let!(:i1) {FactoryBot.create :income, user_id: admin.id, created_at: "2020-10-01 17:00:00"}
  let!(:i2) {FactoryBot.create :income, user_id: admin.id, created_at: "2020-10-02 17:00:00"}


  before do
    login admin
  end

  describe "GET #index" do
    before {get :index, params: {page: 1}}

    it "renders the index template" do
      expect(response).to render_template :index
    end

    it "assigns @incomes" do
      expect(assigns(:incomes).pluck(:id)).to eq [i2.id, i1.id]
    end
  end

  describe "GET #show" do
    context "when valid param" do
      before {get :show, params: {id: income.id}}

      it "valid income" do
        expect(assigns(:income).id).to eq income.id
      end

      it "render show template" do
        expect(response).to render_template :show
      end
    end

    context "when invalid param" do
      before {get :show, params: {id: "test"}}

      it "invalid income" do
        expect(assigns(:income)).to eq nil
      end

      it "render show template" do
        expect(response).to redirect_to admin_incomes_path
      end
    end
  end

  describe "GET #new" do
    before {get :new}

    it "assigns a new income to @income" do
      expect(assigns(:income)).to be_a_new Income  
    end
    
    it "render the new view" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      before {post :create, params: {income: valid_params}}

      it "create a new subject success" do
        expect {post :create, params: {income: valid_params}}.to change(Income, :count).by(1)
      end

      it "should redirect to trainers_subjects_path" do
        expect(response).to redirect_to admin_incomes_path
      end
    end

    context "with invalid attributes" do
      before {post :create, params: {income: invalid_params}}
        
      it "create a new subject fail" do
        expect{post :create, params: {income: invalid_params}}.to change(Income, :count).by(0)
      end

      it "render template subject" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET #edit" do
    context "when valid param" do
      before {get :edit, params: {id: i1.id}}

      it "should have a valid income" do
        expect(assigns(:income).id).to eq i1.id
      end

      it "should render edit template" do
        expect(response).to render_template :edit
      end
    end

    context "when invalid param" do
      before {get :edit, params: {id: "test"}}

      it "should have a invalid income" do
        expect(assigns(:income)).to eq nil
      end

      it "should redirect to admin_posts_path" do
        expect(response).to redirect_to admin_incomes_path
      end
    end
  end
  
  describe "PATCH #update" do
    context "when valid params" do
      before {patch :update, params: {id: income.id, income: {title: "title update"}}}

      it "should correct title" do
        expect(assigns(:income).title).to eq "title update"
      end

      it "should redirect admin_incomes_path" do
        expect(response).to redirect_to admin_incomes_path
      end
    end

    context "when invalid params" do
      before {patch :update, params: {id: income.id, income: invalid_params}}

      it "should a invalid income" do
        expect(assigns(:income).invalid?).to eq true
      end

      it "should render edit template" do
        expect(response).to render_template :edit
      end
    end
  end

  describe "DELETE #destroy" do
    context "when valid params" do
      before { delete :destroy, xhr: true, params: {id: income.id} }

      it "destroy income" do
        expect(assigns(:income).destroyed?).to eq true
      end

      it "show status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when invalid params" do
      before {delete :destroy, xhr: true, params: {id: "test"}}

      it "should a invalid income" do
        expect{subject}.to change(Income, :count).by 0
      end

      it "should redirect to admin_income_path" do
        expect(response).to redirect_to admin_incomes_path
      end
    end
  end

  describe "PATCH #confirm" do
    let(:i3) {FactoryBot.create :income, user_id: admin.id, aasm_state: "pending", budget_id: budget.id, confirmer_id: admin.id}
    context "when valid params" do
      before {patch :confirm, xhr: true, params: {id: i3.id, income: {aasm_state: "approve", budget_id: budget.id, confirmer_id: admin.id}}}
      it "should correct aasm_state" do
        expect(assigns(:income).aasm_state).to eq "approve"
      end

      it "show status 200" do
        expect(response).to have_http_status(200)
      end
    end

    context "when valid params and update fail" do
      before {patch :confirm, xhr: true, params: {id: i3.id, income: {aasm_state: "approve"}}}
      it "should correct aasm_state" do
        expect(assigns(:income).approve?).to eq false
      end

      it "show status 200" do
        expect(response).to have_http_status(200)
      end
    end

    let(:i4) {FactoryBot.create :income, user_id: admin.id, aasm_state: "rejected"}
    context "when invalid params" do
      before {patch :confirm, xhr: true, params: {id: i4.id, income: {aasm_state: "approve"}}}
      it "should a invalid income" do
        expect(assigns(:income).approve?).to eq false
      end

      it "show flash messeage" do
        expect(flash[:danger]).to match(I18n.t("income.noti.show_fail"))
      end
    end
  end

  describe "PATCH #rejected" do
    context "when valid params" do
      before {patch :rejected, xhr: true, params: {id: income.id, income: {aasm_state: "rejected"}}}
      it "should correct aasm_state" do
        expect(assigns(:income).aasm_state).to eq "rejected"
      end

      it "show status 200" do
        expect(response).to have_http_status(200)
      end
    end

    let(:i5) {FactoryBot.create :income, user_id: user.id, aasm_state: "rejected"}
    context "when invalid params" do
      before {patch :rejected, xhr: true, params: {id: i5.id, income: {aasm_state: "rejected"}}}
      it "should a invalid income" do
        expect(assigns(:income).rejected?).to eq true
      end

      it "show flash messeage" do
        expect(flash[:danger]).to match(I18n.t("income.noti.show_fail"))
      end
    end
  end
end
