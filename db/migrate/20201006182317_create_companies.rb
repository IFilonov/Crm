class CreateCompanies < ActiveRecord::Migration[6.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.references :juristic_type, null: false, foreign_key: true
      t.integer :inn
      t.string :ogrn

      t.timestamps
    end
  end
end
