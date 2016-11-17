class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.decimal :price, precision: 24, scale: 6
      t.string :price_currency, limit: 3
    end
  end
end
