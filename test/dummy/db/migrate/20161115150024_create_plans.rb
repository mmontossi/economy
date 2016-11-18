class CreatePlans < ActiveRecord::Migration
  def change
    create_table :plans do |t|
      t.decimal :monthly_price, precision: 24, scale: 6
      t.decimal :annually_price, precision: 24, scale: 6
      t.string :currency, limit: 3

      t.timestamps null: false
    end
  end
end
