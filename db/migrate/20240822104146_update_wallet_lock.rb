class UpdateWalletLock < ActiveRecord::Migration[7.2]
  def change
    add_column :wallets, :lock_version, :integer, default: 0
  end
end
