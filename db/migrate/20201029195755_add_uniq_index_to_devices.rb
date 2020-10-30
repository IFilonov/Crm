class AddUniqIndexToDevices < ActiveRecord::Migration[6.0]
  def change
    add_index :devices, :serial, unique: true
  end
end
