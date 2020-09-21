class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.string :title, null: false, limit: 200
      t.text :content, null: false, limit: 5000
      t.text :reason, null: false, limit: 5000
      t.float :total_amount, null: false, default: 0
      t.string :approver
      t.string :rejecter
      # t.integer :status, null: false, default: 1
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
