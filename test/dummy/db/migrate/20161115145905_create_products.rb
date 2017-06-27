class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.decimal :price, precision: 24, scale: 6
      t.string :price_currency

      t.timestamps null: false
    end
  end
end
