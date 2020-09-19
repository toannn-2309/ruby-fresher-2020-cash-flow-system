class Request < ApplicationRecord
  include AASM

  REQUESTS_PARAMS = %i(title content reason total_amount status).freeze
  PARAMS = %i(title content reason total_amount status aasm_state).freeze

  belongs_to :user
  has_many :request_details, dependent: :destroy
  has_one :payment, dependent: :destroy

  delegate :name, :role, to: :user, prefix: true

  validates :title, presence: true,
    length: {maximum: Settings.validate.title.length}
  validates :content, :reason, presence: true,
    length: {maximum: Settings.validate.content.length}
  validates :total_amount, presence: true,
    numericality: {greater_than: Settings.validate.number_min}

  scope :by_date, ->{order(created_at: :desc)}

  aasm do
    state :pending, initial: true
    state :approve
    state :paid
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
end
