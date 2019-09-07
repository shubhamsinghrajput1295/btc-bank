class ChangeColumnDefaultValueToAccount < ActiveRecord::Migration[6.0]
  def change
  	change_column :accounts, :current_balance, :float, default: 0.0
  end
end
