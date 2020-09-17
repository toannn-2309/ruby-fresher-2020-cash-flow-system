class CreateBudgets < ActiveRecord::Migration[6.0]
  def change
    create_table :budgets do |t|
      t.float :total_budget, null: false, default: 0

      t.timestamps
    end
  end
end
