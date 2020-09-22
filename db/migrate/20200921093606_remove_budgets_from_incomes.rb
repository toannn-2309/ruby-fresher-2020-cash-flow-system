class RemoveBudgetsFromIncomes < ActiveRecord::Migration[6.0]
  def change
    remove_reference :incomes, :budget, null: false, foreign_key: true
  end
end
