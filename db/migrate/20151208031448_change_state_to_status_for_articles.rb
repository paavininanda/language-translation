class ChangeStateToStatusForArticles < ActiveRecord::Migration
  def change
    remove_column :articles, :state, :string

    add_column :articles, :state, :integer, default: 0
  end
end
