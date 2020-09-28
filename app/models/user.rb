class User < ApplicationRecord
  USERS_PARAMS = %i(name email password password_confirmation group_id).freeze
  USERS_PARAMS_UPDATE = %i(name password password_confirmation).freeze
  VALID_EMAIL_REGEX = Settings.validate.email.regex

  attr_accessor :remember_token

  belongs_to :group
  has_many :requests, dependent: :destroy
  has_many :incomes, dependent: :destroy
  has_many :notifications, dependent: :destroy

  enum role: {admin: 1, staff: 2, manager: 3, accountant: 4}

  delegate :name, to: :group, prefix: true

  validates :name, :email, :role, :group_id, presence: true
  validates :name, length: {maximum: Settings.validate.name.length}
  validates :email, length: {maximum: Settings.validate.email.length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: true}
  validates :password, presence: true, allow_nil: true,
    length: {minimum: Settings.validate.password.length}
  validates :role, inclusion: {in: roles.keys}

  before_save :downcase_email

  has_secure_password

  scope :by_date, ->{order(created_at: :desc)}
  scope :filter_by_name_or_email, (lambda do |obj|
    where("name like ? OR email like ?", "#{obj}%", "#{obj}%") if obj.present?
  end)
  scope :by_role, ->(role){where role: role if role.present?}
  scope :by_group, ->(group_id){where group_id: group_id if group_id.present?}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    return false unless remember_digest

    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute :remember_digest, nil
  end

  private

  def downcase_email
    email.downcase!
  end
end
