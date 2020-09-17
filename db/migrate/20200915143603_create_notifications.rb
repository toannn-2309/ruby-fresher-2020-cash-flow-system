class CreateNotifications < ActiveRecord::Migration[6.0]
  def change
    create_table :notifications do |t|
      t.string :title, null: false, limit: 200
      t.text :content, null: false, limit: 5000
      t.boolean :is_viewed, default: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
