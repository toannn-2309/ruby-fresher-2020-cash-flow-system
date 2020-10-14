require "rails_helper"
require "cancan/matchers"
include RSpecTestHelper

RSpec.describe Accountant::IncomesController, type: :controller do
  let(:group) {FactoryBot.create :group}
  let(:user) {FactoryBot.create :user, group_id: group.id, role: "accountant"}
  let(:user_manager) {FactoryBot.create :user, group_id: group.id, role: "manager"}
  let!(:i1) {FactoryBot.create :income, user_id: user_manager.id, created_at: "2020-10-01 17:00:00"}
  let!(:i2) {FactoryBot.create :income, user_id: user_manager.id, created_at: "2020-10-02 17:00:00"}

  before {login user}

  describe "GET #index" do
    before {get :index, params: {page: 1}}
    it "renders the index template" do
      expect(response).to render_template :index
    end

    it "assigns @incomes" do
      expect(assigns(:incomes).pluck(:id)).to eq [i2.id, i1.id]
    end

    it "show status 200" do
      expect(response).to have_http_status(200)
    end
  end
end
