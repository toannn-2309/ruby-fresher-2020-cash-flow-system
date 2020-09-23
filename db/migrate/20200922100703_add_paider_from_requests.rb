class AddPaiderFromRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :paider, :string
  end
end
