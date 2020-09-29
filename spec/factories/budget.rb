FactoryBot.define do
  factory :budget do
    name {["Budget 1", "Budget 2", "Budget 3"].sample}
    total_budget {5000}
  end
end
