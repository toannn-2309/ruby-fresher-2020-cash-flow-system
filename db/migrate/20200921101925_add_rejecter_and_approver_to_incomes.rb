class AddRejecterAndApproverToIncomes < ActiveRecord::Migration[6.0]
  def change
    add_column :incomes, :rejecter, :string
    add_column :incomes, :confirmer, :string
  end
end
