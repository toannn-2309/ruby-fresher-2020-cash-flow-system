class AddAasmStateToRequests < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :aasm_state, :string
  end
end
