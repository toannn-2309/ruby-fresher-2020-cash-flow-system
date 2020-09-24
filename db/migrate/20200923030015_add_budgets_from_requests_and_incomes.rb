class AddBudgetsFromRequestsAndIncomes < ActiveRecord::Migration[6.0]
  def change
    add_reference :incomes, :budget, null: false, foreign_key: true, index: true
    add_reference :requests, :budget, null: false, foreign_key: true, index: true
    add_column :budgets, :name, :string
  end
end
