class User < ApplicationRecord
  VALID_EMAIL_REGEX = Settings.user.email.regex

  belongs_to :group
  has_many :requests, dependent: :destroy
  has_many :incomes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  validates :name, :email, :password, :role, presence: true
  validates :name, length: {maximum: Settings.validate.name.length}
  validates :email, length: {maximum: Settings.validate.email.length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: true}
  validates :password, length: {minimum: Settings.validate.password.length}
  validates :role, inclusion: {in: roles.keys}

  enum role: {admin: 1, staff: 2, manager: 3, accountant: 4}
end
