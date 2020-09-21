class Income < ApplicationRecord
  include AASM

  INCOME_PARAMS = %i(title content amount_income aasm_state).freeze

  belongs_to :user

  delegate :name, :role, to: :user, prefix: true

  validates :amount_income, presence: true,
    numericality: {greater_than: Settings.validate.number_min}
  validates :title, presence: true,
    length: {maximum: Settings.validate.title.length}
  validates :content, presence: true,
    length: {maximum: Settings.validate.content.length}

  scope :by_date, ->{order created_at: :desc}

  aasm do
    state :pending, initial: true
    state :approve
    state :rejected

    event :confirm do
      transitions from: :pending, to: :approve
    end

    event :rejected do
      transitions from: [:pending, :approve], to: :rejected
    end
  end
end
