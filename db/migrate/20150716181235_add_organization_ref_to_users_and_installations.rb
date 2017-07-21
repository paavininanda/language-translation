class AddOrganizationRefToUsersAndInstallations < ActiveRecord::Migration
  def change
    add_reference :users, :organization, index: true, foreign_key: true
    add_reference :installations, :organization, index: true, foreign_key: true
  end
end
