class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions, id: :uuid do |t|
      t.decimal :amount
      t.string :transaction_type
      t.references :source_wallet, type: :uuid, null: true, foreign_key: { to_table: :wallets }
      t.references :destination_wallet, type: :uuid, null: true, foreign_key: { to_table: :wallets }

      t.timestamps
    end
  end
end
