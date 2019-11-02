class CreateOffers < ActiveRecord::Migration[6.0]
  def change
    create_table :offers do |t|
      t.string :title,    null: false
      t.text :description
      t.decimal :price,   null: false, precision: 8, scale: 2

      t.timestamps
    end

    # index for sorting offers from newest
    add_index :offers, [:created_at]
  end
end
