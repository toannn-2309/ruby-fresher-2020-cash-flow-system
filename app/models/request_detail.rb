class RequestDetail < ApplicationRecord
  belongs_to :request

  validates :amount, presence: true,
    numericality: {greater_than: Settings.validate.number_min}
  validates :content, presence: true,
    length: {maximum: Settings.validate.content.length}
end
