class CreateBudgets < ActiveRecord::Migration[6.0]
  def change
    create_table :budgets do |t|
      t.float :total_budget

      t.timestamps
    end
  end
end
