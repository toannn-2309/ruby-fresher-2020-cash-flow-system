class Income < ApplicationRecord
  belongs_to :user
  belongs_to :budget

  validates :amount_income, presence: true,
    numericality: {greater_than: Settings.validate.number_min}
  validates :title, presence: true,
    length: {maximum: Settings.validate.title.length}
  validates :content, :reason, presence: true,
    length: {maximum: Settings.validate.content.length}
end
