require "rails_helper"
require "cancan/matchers"
include RSpecTestHelper

RSpec.describe Manager::RequestsController, type: :controller do
  let(:group) {FactoryBot.create :group}
  let(:user) {FactoryBot.create :user, group_id: group.id, role: "manager"}

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
end
