# == Schema Information
#
# Table name: articles
#
#  id          :integer          not null, primary key
#  english     :text
#  phonetic    :text
#  created_at  :datetime
#  updated_at  :datetime
#  picture     :string
#  language_id :integer
#  tsv_data    :tsvector
#  category_id :integer
#  state       :string           default("draft")
#

class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :english, :phonetic, :category, :picture_url, :created_at
end
