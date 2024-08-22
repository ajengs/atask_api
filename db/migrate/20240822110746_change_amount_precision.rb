class ChangeAmountPrecision < ActiveRecord::Migration[7.2]
  def change
    change_column :transactions, :amount, :decimal, precision: 10, scale: 2
    change_column :wallets, :balance, :decimal, precision: 10, scale: 2
  end
end
