class ChangeCompanyColumns < ActiveRecord::Migration[6.0]
  def change
    change_column :companies, :inn, 'bigint USING CAST(inn AS bigint)'
    change_column :companies, :ogrn, 'bigint USING CAST(ogrn AS bigint)'
  end
end
