group_name = ["Group 1", "Group 2", "Group 3", "Group 4"]

4.times do |n|
  Group.create!(
    name: group_name[n]
  )
end
