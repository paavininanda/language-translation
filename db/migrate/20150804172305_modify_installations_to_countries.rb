class ModifyInstallationsToCountries < ActiveRecord::Migration
  def change
    remove_column :installations, :email, :string
    remove_column :installations, :address, :text
    remove_column :installations, :contact, :string
    rename_column :installations, :installation, :name
    rename_column :sites, :installation_id, :country_id
    add_reference :installations, :user, index: true, foreign_key: true
    rename_table :installations, :countries
  end
end
