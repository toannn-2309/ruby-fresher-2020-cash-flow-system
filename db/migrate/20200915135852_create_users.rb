class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, limit: 50, null: false
      t.string :email, null: false
      t.string :avatar
      t.string :password_digest
      t.integer :role, null: false, default: 2
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
    add_index :users, :email
  end
end
