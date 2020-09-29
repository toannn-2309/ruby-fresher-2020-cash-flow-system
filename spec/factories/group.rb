FactoryBot.define do
  factory :group do
    name {["Group 1", "Group 2", "Group 3", "Group 4"].sample}
  end
end
