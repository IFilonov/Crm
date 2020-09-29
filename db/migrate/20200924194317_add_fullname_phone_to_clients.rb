class AddFullnamePhoneToClients < ActiveRecord::Migration[6.0]
  def change
    add_column :clients, :fullname, :string
    add_column :clients, :phone, :string
  end
end
