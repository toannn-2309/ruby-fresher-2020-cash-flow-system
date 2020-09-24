class AddRejecterAndApproverToIncomes < ActiveRecord::Migration[6.0]
  def change
    add_column :incomes, :rejecter_id, :integer
    add_column :incomes, :confirmer_id, :integer
  end
end
