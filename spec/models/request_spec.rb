require "rails_helper"

RSpec.describe Request, type: :model do
  subject {request}

  let(:group) {FactoryBot.create :group}
  let(:budget) {FactoryBot.create :budget}
  let(:user) {FactoryBot.create :user, group_id: group.id}
  let(:request) {FactoryBot.build :request, user_id: user.id, budget_id: budget.id}

# Test associations
  describe "Associations" do
    [:user, :budget].each do |field|
      it "belong to user and budget" do
        is_expected.to belong_to field
      end
    end

    it "has many request details" do
      is_expected.to have_many(:request_details).dependent(:destroy)
    end

    it "belong to approver" do
      is_expected.to belong_to(:approver).optional(:true).with_foreign_key(:approver_id).class_name(User.name)
    end 

    it "belong to paider" do
      is_expected.to belong_to(:paider).optional(:true).with_foreign_key(:paider_id).class_name(User.name)
    end

    it "belong to rejecter" do
      is_expected.to belong_to(:rejecter).optional(:true).with_foreign_key(:rejecter_id).class_name(User.name)
    end
  end

# Test nested attributes
  describe "Nested attributes" do
    it "request details" do
      is_expected.to accept_nested_attributes_for(:request_details).allow_destroy true
    end
  end

# Test delegations
  describe "delegations" do
    [:user, :budget, :approver, :paider, :rejecter].each do |field|
      it {should delegate_method(:name).to(field).with_prefix}
    end

    it {should delegate_method(:role).to(:user).with_prefix}
  end

# Test validations
  describe "Validations" do
    before {request.save}

    it "valid all field" do
      expect(subject).to be_valid
    end

    [:title, :content, :total_amount].each do |field|
      it {is_expected.to validate_presence_of(field).with_message("can't be blank")}
    end

    it {is_expected.to validate_length_of(:title).is_at_most(Settings.validate.title.length)}

    it {is_expected.to validate_length_of(:content).is_at_most(Settings.validate.content.length)}

    it {is_expected.to validate_numericality_of(:total_amount).is_greater_than(Settings.validate.number_min)}
  end

# Test scope
  describe "scope" do
    let!(:r2) {FactoryBot.create :request, user_id: user.id, created_at: "2020-09-30 17:00:00", budget_id: budget.id, aasm_state: "pending"}
    let!(:r3) {FactoryBot.create :request, user_id: user.id, created_at: "2020-09-28 17:00:00", budget_id: budget.id, aasm_state: "rejected"}
    let!(:r6) {FactoryBot.create :request, user_id: user.id, budget_id: budget.id, created_at: "2020-09-26 17:00:00", aasm_state: "paid", paider_id: user.id}

    it "order by date" do
      expect(Request.by_date.first.id).to eq r2.id
    end

    it "order by date and state" do
      expect(Request.by_date_and_state_asc.first.id).to eq r6.id
    end

    it "request not pending" do
      expect(Request.status_not_pending.first.id).to eq r3.id
    end

    it "request by update" do
      expect(Request.by_updated.first.id).to eq r6.id
    end

    it "request by request paid" do
      expect(Request.by_request_paid.first.id).to eq r6.id
    end
  end

# Test aasm
  describe "delegations" do
    let(:r4) {FactoryBot.create :request, user_id: user.id, budget_id: budget.id, aasm_state: "pending"}
    it {expect(r4).to transition_from(:pending).to(:approve).on_event(:review)}

    it {expect(r4).to transition_from(:approve).to(:paid).on_event(:confirm)}

    [:pending, :approve, :paid].each do |field|
      it {expect(r4).to transition_from(field).to(:rejected).on_event(:rejected)}
    end
  end

# Test instance method
  describe "#subtract_the_budget" do
    let(:b1) {FactoryBot.create :budget, name: "Budget 1", total_budget: 5000.0} 
    let(:r5) {FactoryBot.create :request, user_id: user.id, total_amount: "200", budget_id: b1.id, aasm_state: "paid"}
    before {r5.subtract_the_budget}
    it "test subtract the budget" do
      b1.reload
      expect(b1.total_budget).to eq 4800
    end
  end

# Test ransackable_attributes
  describe "#ransackable_attributes" do
    context "when auth_object is nil" do
      subject {Request.ransackable_attributes}

      it {should include "name_title"}
      it {should include "aasm_state"}
      it {should include "created_at"}
      it {should include "total_amount"}
      it {should_not include "updated_at"}

      if Ransack::SUPPORTS_ATTRIBUTE_ALIAS
        it {should include "name_title"}
      end
    end
  end
end
