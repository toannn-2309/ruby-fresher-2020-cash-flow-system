FactoryBot.define do
  factory :request_detail do
    content {Faker::Lorem.sentence(word_count: 15)}
    amount {rand(1..100)}
    association :request
  end
end
