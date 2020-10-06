group_name = ["Group 1", "Group 2", "Group 3", "Group 4"]
budget_name = ["Budget 1", "Budget 2", "Budget 3"]

4.times do |n|
  Group.create!(
    name: group_name[n]
  )
end

3.times do |n|
  Budget.create!(
    name: budget_name[n],
    total_budget: 5000
  )
end

user_ids = []
request_ids = []
income_ids = []

User.create!(
  name: "admin",
  email: "admin@gmail.com",
  password: "Password123",
  password_confirmation: "Password123",
  role: 1,
  group_id: 1,
  confirmed_at: Time.zone.now
)

20.times do |n|
  user = User.create!(
    name: Faker::Name.middle_name,
    email: "user_#{n+1}@gmail.com",
    password: "Password123",
    password_confirmation: "Password123",
    role: 2,
    group_id: rand(1..4),
    confirmed_at: Time.zone.now
  )

  user = User.create!(
    name: Faker::Name.middle_name,
    email: "manager_#{n+1}@gmail.com",
    password: "Password123",
    password_confirmation: "Password123",
    role: 3,
    group_id: rand(1..4),
    confirmed_at: Time.zone.now
  )

  user = User.create!(
    name: Faker::Name.middle_name,
    email: "accountant_#{n+1}@gmail.com",
    password: "Password123",
    password_confirmation: "Password123",
    role: 4,
    group_id: rand(1..4),
    confirmed_at: Time.zone.now
  )
  user_ids << user.id
end

80.times do |n|
  request = Request.create!(
    user_id: rand(2..61),
    title: Faker::Lorem.sentence(word_count: 5),
    content: Faker::Lorem.sentence(word_count: 15),
    reason: Faker::Lorem.sentence(word_count: 40),
    total_amount: rand(1..500),
    budget_id: 1
  )
  request_ids << request.id
end

40.times do |n|
  income = Income.create!(
    user_id: rand(22..41),
    title: Faker::Lorem.sentence(word_count: 5),
    content: Faker::Lorem.sentence(word_count: 15),
    amount_income: rand(1..500),
    budget_id: 1
  )
  income_ids << income.id
end
