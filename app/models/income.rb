class Income < ApplicationRecord
  include AASM

  INCOME_PARAMS = %i(title content amount_income aasm_state).freeze

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
    @amount_income = Income.find_by(id: id).amount_income
    @budget = Budget.find_by id: budget_id
    @total_budget = @budget.total_budget
    @result = @total_budget + @amount_income
    @budget.update total_budget: @result
  end
end
