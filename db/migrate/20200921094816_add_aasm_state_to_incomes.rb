class AddAasmStateToIncomes < ActiveRecord::Migration[6.0]
  def change
    add_column :incomes, :aasm_state, :string
  end
end
