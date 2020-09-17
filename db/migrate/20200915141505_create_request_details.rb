class CreateRequestDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :request_details do |t|
      t.float :amount, null: false, default: 0
      t.text :content, null: false, limit: 5000
      t.references :request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
