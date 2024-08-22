class CreateAuthTokens < ActiveRecord::Migration[7.2]
  def change
    create_table :auth_tokens do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.string :token
      t.datetime :expires_at, null: false

      t.timestamps
    end
    add_index :auth_tokens, :token
  end
end
