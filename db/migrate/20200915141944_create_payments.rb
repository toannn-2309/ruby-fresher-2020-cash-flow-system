class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.string :title, null: false, limit: 200
      t.text :content, null: false, limit: 5000
      t.float :amount_spent, null: false, default: 0
      t.string :paider, null: false
      t.references :request, :budget, null: false, foreign_key: true

      t.timestamps
    end
  end
end
