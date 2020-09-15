class Budget < ApplicationRecord
  has_many :payments, dependent: :destroy
  has_many :incomes, dependent: :destroy
end
