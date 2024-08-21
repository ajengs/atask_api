class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks, id: :uuid do |t|
      t.string :symbol
      t.string :company_name

      t.timestamps
    end
  end
end
