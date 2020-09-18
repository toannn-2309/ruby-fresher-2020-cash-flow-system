group_name = ["Group 1", "Group 2", "Group 3", "Group 4"]

4.times do |n|
  Group.create!(
    name: group_name[n]
  )
end

user_ids = []
request_ids = []

User.create!(
  name: "admin",
  email: "admin@gmail.com",
  password: "password",
  password_confirmation: "password",
  role: 1,
  group_id: 1
)

20.times do |n|
  user = User.create!(
    name: Faker::Name.middle_name,
    email: "example_#{n+1}@gmail.com",
    password: "password",
    password_confirmation: "password",
    role: rand(2..4),
    group_id: rand(1..4)
  )
  user_ids << user.id
end

40.times do |n|
  request = Request.create!(
    # user_id: user_ids[n],
    user_id: rand(2..21),
    title: Faker::Lorem.sentence(word_count: 5),
    content: Faker::Lorem.sentence(word_count: 15),
    reason: Faker::Lorem.sentence(word_count: 40),
    status: rand(1..4),
    total_amount: rand(1..500)
  )
  request_ids << request.id
end
