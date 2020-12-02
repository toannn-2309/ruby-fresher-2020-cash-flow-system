class User < ApplicationRecord
  USERS_PARAMS = %i(name email password password_confirmation group_id).freeze
  USERS_PARAMS_UPDATE = %i(name password password_confirmation).freeze
  VALID_EMAIL_REGEX = Settings.validate.email.regex
  VALID_PASSWORD_REGEX = Settings.validate.password.regex

  belongs_to :group
  has_many :requests, dependent: :destroy
  has_many :incomes, dependent: :destroy
  has_many :notifications, foreign_key: :receiver_id, dependent: :destroy
  has_many :send_notifications, foreign_key: :sender_id, dependent: :destroy

  enum role: {admin: 1, staff: 2, manager: 3, accountant: 4}

  delegate :name, to: :group, prefix: true

  validates :name, :email, :role, :group_id, presence: true
  validates :name, length: {maximum: Settings.validate.name.length}
  validates :email, length: {maximum: Settings.validate.email.length},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: true}
  validates :password, presence: true, allow_nil: true,
    length: {minimum: Settings.validate.password.length_min,
             maximum: Settings.validate.password.length_max}
  validates :role, inclusion: {in: roles.keys}
  validate :password_regex

  devise :database_authenticatable, :registerable, :rememberable, :validatable,
         :confirmable, :recoverable, :lockable,
         :omniauthable, omniauth_providers: [:facebook]

  scope :by_date, ->{order(created_at: :desc)}
  scope :filter_by_name_or_email, (lambda do |obj|
    where("name like ? OR email like ?", "#{obj}%", "#{obj}%") if obj.present?
  end)
  scope :by_role, ->(role){where role: role if role.present?}
  scope :by_group, ->(group_id){where group_id: group_id if group_id.present?}

  # rubocop:disable Metrics/AbcSize
  def self.from_omniauth access_token
    data = access_token.info
    result = User.find_by email: data.email
    return result if result

    where(provider: access_token.provider,
      uid: access_token.uid).first_or_create do |user|
      user.email = data.email
      user.password = Devise.friendly_token[0, 20]
      user.name = data.name
      user.uid = access_token.uid
      user.role = Settings.user.role
      user.group_id = Settings.user.group
      user.provider = access_token.provider
      user.skip_confirmation!
    end
  end
  # rubocop:enable Metrics/AbcSize

  private

  def password_regex
    return unless password.present? && !password.match(VALID_PASSWORD_REGEX)

    errors.add :password, I18n.t("user.er_regex")
  end
end
