FactoryBot.define do
  factory :user do
    name {Faker::Name.middle_name}
    email {Faker::Internet.email}
    password {"Password123"}
    password_confirmation {"Password123"}
    role {rand(1..4)}
    confirmed_at {Time.zone.now}
    association :group
  end
end
