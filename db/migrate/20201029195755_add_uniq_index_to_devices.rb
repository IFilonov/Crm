class AddUniqIndexToDevices < ActiveRecord::Migration[6.0]
  def change
    add_index :devices, :serial, unique: true
    add_index :companies, [:name, :inn, :ogrn], unique: true
  end
end
