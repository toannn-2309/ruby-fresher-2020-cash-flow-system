class Budget < ApplicationRecord
  has_many :payments, dependent: :destroy
  has_many :incomes, dependent: :destroy

  validates :total_budget, presence: true,
    numericality: {greater_than: Settings.validate.number_min}
end
