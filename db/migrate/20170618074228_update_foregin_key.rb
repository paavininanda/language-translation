class UpdateForeginKey < ActiveRecord::Migration
  def change
    # remove the old foreign_key
    remove_foreign_key :countries, :organizations

    # add the new foreign_key
    add_foreign_key :countries, :organizations, on_delete: :cascade
  end
end
