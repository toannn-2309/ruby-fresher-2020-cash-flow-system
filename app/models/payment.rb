class Payment < ApplicationRecord
  belongs_to :request
  belongs_to :budget

  validates :paider, presence: true
  validates :amount_spent, presence: true,
    numericality: {greater_than: Settings.validate.number_min}
  validates :content, presence: true,
    length: {maximum: Settings.validate.content.length}
  validates :title, presence: true,
    length: {maximum: Settings.validate.title.length}
end
