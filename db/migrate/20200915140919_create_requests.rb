class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.string :title
      t.text :content
      t.text :reason
      t.float :total_amount
      t.string :approver
      t.integer :status
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
