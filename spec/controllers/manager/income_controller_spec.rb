require "rails_helper"
require "cancan/matchers"
include RSpecTestHelper

RSpec.describe Manager::IncomesController, type: :controller do
  let(:group) {FactoryBot.create :group}
  let(:user) {FactoryBot.create :user, group_id: group.id, role: "manager"}
  let(:budget) {FactoryBot.create :budget}
  let(:income) {FactoryBot.create :income, user_id: user.id, budget_id: budget.id}
  let(:valid_params) {FactoryBot.attributes_for :income, user_id: user.id, budget_id: budget.id}
  let(:invalid_params) {FactoryBot.attributes_for :income, title: nil}
  let!(:i1) {FactoryBot.create :income, user_id: user.id, created_at: "2020-10-01 17:00:00"}
  let!(:i2) {FactoryBot.create :income, user_id: user.id, created_at: "2020-10-02 17:00:00"}

  before {login user}

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
        expect(response).to redirect_to manager_incomes_path
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
        expect(response).to redirect_to manager_incomes_path
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

      it "should redirect to manager_incomes_path" do
        expect(response).to redirect_to manager_incomes_path
      end
    end
  end

  describe "PATCH #update" do
    context "when valid params" do
      before {patch :update, params: {id: income.id, income: {title: "title update"}}}

      it "should correct title" do
        expect(assigns(:income).title).to eq "title update"
      end

      it "should redirect manager_incomes_path" do
        expect(response).to redirect_to manager_incomes_path
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
      before { delete :destroy, params: {id: income.id} }

      it "destroy income" do
        expect(assigns(:income).destroyed?).to eq true
      end

      it "should redirect to admin_incomes_path" do
        expect(response).to redirect_to manager_incomes_path
      end
    end

    context "when invalid params" do
      before {delete :destroy, params: {id: "test"}}

      it "should a invalid income" do
        expect{subject}.to change(Income, :count).by 0
      end

      it "should redirect to manager_income_path" do
        expect(response).to redirect_to manager_incomes_path
      end
    end

    context "when a failure income destroy" do
      before do
        allow_any_instance_of(Income).to receive(:destroy).and_return false
        delete :destroy, params: {id: income.id}
      end

      it "flash error message" do
        expect(flash[:danger]).to eq I18n.t("income.noti.destroy_fail")
      end

      it "should redirect to manager_incomes_path" do
        expect(response).to redirect_to manager_incomes_path
      end
    end
  end
end
