class Budget < ApplicationRecord
  validates :total_budget, presence: true,
    numericality: {greater_than: Settings.validate.number_min}
end
