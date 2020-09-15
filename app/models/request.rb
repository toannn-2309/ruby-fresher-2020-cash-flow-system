class Request < ApplicationRecord
  belongs_to :user
  has_many :request_details, inverse_of: :request, dependent: :destroy
  has_one :payment, dependent: :destroy
end
