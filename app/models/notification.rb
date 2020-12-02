class Notification < ApplicationRecord
  belongs_to :receiver, class_name: User.name, foreign_key: :receiver_id
  belongs_to :sender, class_name: User.name, foreign_key: :sender_id

  enum status: {unread: 0, read: 1}

  validates :content, presence: true,
    length: {maximum: Settings.validate.content.length}

  scope :order_created_at_desc, ->{order created_at: :desc}

  delegate :name, to: :sender, prefix: true
end
