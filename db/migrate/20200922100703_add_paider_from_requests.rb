class AddPaiderFromRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :paider_id, :integer
  end
end
