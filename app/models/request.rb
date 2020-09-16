class Request < ApplicationRecord
  belongs_to :user
  has_many :request_details, dependent: :destroy
  has_one :payment, dependent: :destroy

  validates :title, presence: true,
    length: {maximum: Settings.validate.title.length}
  validates :content, :reason, presence: true,
    length: {maximum: Settings.validate.content.length}
  validates :total_amount, presence: true,
    numericality: {greater_than: Settings.validate.number_min}
  validates :status, presence: true, inclusion: {in: statues.keys}

  enum status: {pending: 1, approved: 2, paid: 3, rejected: 4}
end
