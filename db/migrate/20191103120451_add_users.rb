class AddUsers < ActiveRecord::Migration[6.0]
  def up
    create_table :users do |t|
      t.string :email,           null: false
      t.string :password_digest, null: false
      t.boolean :is_active,      null: false, default: true
      t.string :name,            null: false

      t.timestamps
    end

    add_index :users, %i[email], unique: true
  end

  def down
    drop_table :users
  end
end
