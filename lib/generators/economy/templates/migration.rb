class CreateExchanges < ActiveRecord::Migration
  def change
    create_table :exchanges do |t|
      t.string :service, limit: 30
      t.string :from, limit: 3
      t.string :to, limit: 3
      t.decimal :rate, precision: 24, scale: 12

      t.timestamps null: false
    end

    add_index :exchanges, %i(from to)
  end
end
