class CreateClients < ActiveRecord::Migration[7.1]
  def change
    create_table :clients do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_1
      t.string :phone_2
      t.text :notes
      t.boolean :new_client
      t.string :mail
      t.date :birthdate
      t.references :registration, null: false, foreign_key: true

      t.timestamps
    end
  end
end
