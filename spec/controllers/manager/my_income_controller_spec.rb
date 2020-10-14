require "rails_helper"
require "cancan/matchers"
include RSpecTestHelper

RSpec.describe Manager::MyIncomesController, type: :controller do
  let(:group) {FactoryBot.create :group}
  let(:user) {FactoryBot.create :user, group_id: group.id, role: "manager"}
  let(:budget) {FactoryBot.create :budget}
  let(:my_income) {FactoryBot.create :income, user_id: user.id, budget_id: budget.id}
  let!(:i1) {FactoryBot.create :income, user_id: user.id, created_at: "2020-10-01 17:00:00"}
  let!(:i2) {FactoryBot.create :income, user_id: user.id, created_at: "2020-10-02 17:00:00"}

  before {login user}

  describe "GET #index" do
    before {get :index, params: {page: 1}}

    it "renders the index template" do
      expect(response).to render_template :index
    end

    it "show status 200" do
      expect(response).to have_http_status(200)
    end

    it "assigns @my_incomes" do
      expect(assigns(:my_incomes).pluck(:id)).to eq [i2.id, i1.id]
    end
  end
end
