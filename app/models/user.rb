class User < ApplicationRecord
  belongs_to :group
  has_many :requests, dependent: :destroy
  has_many :incomes, dependent: :destroy
  has_many :notifications, dependent: :destroy
end
