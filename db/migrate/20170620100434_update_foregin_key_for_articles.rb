class UpdateForeginKeyForArticles < ActiveRecord::Migration
  def change
  	# remove the old foreign_key
    remove_foreign_key :audios, :articles

    # add the new foreign_key
    add_foreign_key :audios, :articles, on_delete: :cascade
  end
end
