class Request < ApplicationRecord
  include AASM

  REQUESTS_PARAMS = [
    :title, :content, :reason, :total_amount,
    :aasm_state, :budget_id,
    request_details_attributes: [:id, :amount, :content, :_destroy].freeze
  ].freeze

  belongs_to :user
  has_many :request_details, dependent: :destroy
  belongs_to :budget
  belongs_to :approver, foreign_key: :approver_id,
                      optional: true, class_name: User.name
  belongs_to :paider, foreign_key: :paider_id,
                      optional: true, class_name: User.name
  belongs_to :rejecter, foreign_key: :rejecter_id,
                      optional: true, class_name: User.name
  accepts_nested_attributes_for :request_details, allow_destroy: true,
    reject_if: :all_blank

  delegate :name, :role, to: :user, prefix: true
  delegate :name, to: :budget, prefix: true
  delegate :name, to: :approver, prefix: true
  delegate :name, to: :paider, prefix: true
  delegate :name, to: :rejecter, prefix: true

  validates :title, presence: true,
    length: {maximum: Settings.validate.title.length}
  validates :content, :reason, presence: true,
    length: {maximum: Settings.validate.content.length}
  validates :total_amount, presence: true,
    numericality: {greater_than: Settings.validate.number_min}

  scope :by_date, ->{order created_at: :desc}
  scope :by_date_and_state_asc, ->{order aasm_state: :asc, created_at: :desc}
  scope :requests_by_group, ->(group_id){where(users: {group_id: group_id})}
  scope :status_not_pending, ->{where aasm_state: %w(approve paid rejected)}
  scope :by_updated, ->{order updated_at: :desc}
  scope :by_request_paid, ->{where.not paider_id: nil}

  aasm do
    state :pending, initial: true
    state :approve
    state :paid, after_enter: :subtract_the_budget
    state :rejected

    event :review do
      transitions from: :pending, to: :approve
    end

    event :confirm do
      transitions from: :approve, to: :paid
    end

    event :rejected do
      transitions from: [:pending, :approve, :paid], to: :rejected
    end
  end

  def subtract_the_budget
    total_amount = Request.find_by(id: id).total_amount
    budget = Budget.find_by id: budget_id
    total_budget = budget.total_budget
    result = total_budget - total_amount
    budget.update total_budget: result
  end
end
