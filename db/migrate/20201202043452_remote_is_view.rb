class RemoteIsView < ActiveRecord::Migration[6.0]
  def change
    remove_column :notifications, :is_viewed
    add_column :notifications, :status, :integer, default: 0
  end
end
