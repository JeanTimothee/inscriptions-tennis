class ChangeNewClientColumn < ActiveRecord::Migration[7.1]
  def change
    remove_column :clients, :new_client, :boolean
    add_column :clients, :re_registration, :boolean, null: false, default: false
  end
end
