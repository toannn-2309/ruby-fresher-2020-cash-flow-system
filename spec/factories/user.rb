FactoryBot.define do
  factory :user do
    name {Faker::Name.middle_name}
    email {Faker::Internet.email}
    password {"password"}
    password_confirmation {"password"}
    role {rand(1..4)}
    association :group
  end
end
