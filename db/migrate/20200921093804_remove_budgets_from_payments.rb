class RemoveBudgetsFromPayments < ActiveRecord::Migration[6.0]
  def change
    remove_reference :payments, :budget, null: false, foreign_key: true
  end
end
