class CreateAudios < ActiveRecord::Migration
  def change
    create_table :audios do |t|
      t.text :content
      t.string :audio
      t.references :article, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
