FactoryBot.define do
  factory :request do
    title {Faker::Lorem.sentence(word_count: 5)}
    content {Faker::Lorem.sentence(word_count: 15)}
    reason {Faker::Lorem.sentence(word_count: 40)}
    total_amount {rand(1..500)}
    association :budget
    association :user
  end
end
