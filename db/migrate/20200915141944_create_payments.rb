class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.string :title
      t.text :content
      t.float :amount_spent
      t.string :paider
      t.references :request, :budget , null: false, foreign_key: true

      t.timestamps
    end
  end
end
