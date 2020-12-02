class ChangeTableNotification < ActiveRecord::Migration[6.0]
  def change
    remove_reference :notifications, :user, null: false, foreign_key: true
    remove_column :notifications, :title
    add_column :notifications,:sender_id, :integer, null: false
    add_column :notifications, :receiver_id, :integer, null: false
  end
end
