class CreateWallets < ActiveRecord::Migration[7.2]
  def change
    create_table :wallets, id: :uuid do |t|
      t.decimal :balance
      t.references :account, type: :uuid, polymorphic: true, null: false

      t.timestamps
    end
  end
end
