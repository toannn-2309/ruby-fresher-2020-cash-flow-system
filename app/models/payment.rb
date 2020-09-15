class Payment < ApplicationRecord
  belongs_to :request
  belongs_to :budget
end
