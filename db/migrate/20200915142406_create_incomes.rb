class CreateIncomes < ActiveRecord::Migration[6.0]
  def change
    create_table :incomes do |t|
      t.string :title, null: false, limit: 200
      t.text :content, null: false, limit: 5000
      t.float :amount_income, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :budget, null: false, foreign_key: true

      t.timestamps
    end
  end
end
