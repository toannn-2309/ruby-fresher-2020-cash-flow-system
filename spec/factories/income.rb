FactoryBot.define do
  factory :income do
    title {Faker::Lorem.sentence(word_count: 5)}
    content {Faker::Lorem.sentence(word_count: 15)}
    amount_income {rand(1..500)}
    aasm_state {"pending"}
    association :budget
    association :user
  end
end
