class CreateRequestDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :request_details do |t|
      t.float :amount
      t.text :description
      t.references :request, null: false, foreign_key: true

      t.timestamps
    end
  end
end
