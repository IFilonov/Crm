class CreateDevices < ActiveRecord::Migration[6.0]
  def change
    create_table :devices do |t|
      t.string :name
      t.string :type
      t.string :serial
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
