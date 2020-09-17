class Group < ApplicationRecord
  has_many :users, dependent: :destroy

  validates :name, presence: true,
    length: {maximum: Settings.validate.name.length}
end
