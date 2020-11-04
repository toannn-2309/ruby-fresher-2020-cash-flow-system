class Income < ApplicationRecord
  include AASM

  INCOME_PARAMS = %i(title content amount_income aasm_state budget_id).freeze
  INCOME_PARAMS_ADMIN_EDIT = %i(title content aasm_state budget_id).freeze
  INCOME_LOAD = %i(budget user confirmer rejecter).freeze
  MY_INCOME_LOAD = %i(budget confirmer rejecter).freeze

  belongs_to :user
  belongs_to :budget
  belongs_to :confirmer, foreign_key: :confirmer_id,
                        optional: true, class_name: User.name
  belongs_to :rejecter, foreign_key: :rejecter_id,
                        optional: true, class_name: User.name

  delegate :name, :role, to: :user, prefix: true
  delegate :name, to: :budget, prefix: true
  delegate :name, to: :confirmer, prefix: true
  delegate :name, to: :rejecter, prefix: true

  validates :amount_income, presence: true,
    numericality: {greater_than: Settings.validate.number_min}
  validates :title, presence: true,
    length: {maximum: Settings.validate.title.length}
  validates :content, presence: true,
    length: {maximum: Settings.validate.content.length}

  scope :by_date, ->{order created_at: :desc}
  scope :incomes_by_group, ->(group_id){where(users: {group_id: group_id})}
  scope :by_updated, ->{order updated_at: :desc}
  scope :by_request_confirm, ->{where.not confirmer_id: nil}

  aasm do
    state :pending, initial: true
    state :approve, after_enter: :add_the_budget
    state :rejected

    event :confirm do
      transitions from: :pending, to: :approve
    end

    event :rejected do
      transitions from: [:pending, :approve], to: :rejected
    end
  end

  def add_the_budget
    amount_income = Income.find_by(id: id).amount_income
    budget = Budget.find_by id: budget_id
    total_budget = budget.total_budget
    result = total_budget + amount_income
    budget.update total_budget: result
  end

  searchkick word_start: [:title], highlight: [:title], callbacks: :async

  after_commit :reset_index, if: ->(model){model.previous_changes.key?("title")}

  # đánh lại index
  def reset_index
    Income.search_index.delete
    # Income.reindex
    Income.reindex async: true
  end

  # Kiểm soát những dữ liệu nào sẽ được đánh index
  def search_data
    {title: title}
  end
end
