class RequestDetail < ApplicationRecord
  belongs_to :request, inverse_of: :request_details
end
