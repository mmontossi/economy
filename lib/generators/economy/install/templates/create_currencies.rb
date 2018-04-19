class CreateCurrencies < ActiveRecord::Migration[5.1]
  def change
    create_table :currencies do |t|
      t.string :iso_code
      t.integer :iso_number
      t.decimal :usd_rate, precision: 24, scale: 12
      t.string :symbol
      t.integer :decimals

      t.timestamps
    end
  end
end
