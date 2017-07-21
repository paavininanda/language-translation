class ChangeLoginApprovalFromStringToDatetime < ActiveRecord::Migration
  def change
    add_column :users, :login_approval_at, :datetime

    User.reset_column_information
    User.all.each do |user|
      user.login_approval_at = user.login_approval == 'Yes' ? Time.now : nil
      user.save
    end

    remove_column :users, :login_approval, :string
  end
end
