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

require 'test_helper'

class ArticleTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  it "is invalid without any field" do
    article = build(:article, english: nil, phonetic: nil, picture: nil)
    assert_not article.save, "Saved the article/photo without any field"
  end

  it "is invalid without a :language_id" do
    article = build(:article, language_id: nil, phonetic: "Cta")
    assert_not article.save, "Saved the article without language"
  end

  it "is invalid without saving article :picture value" do
    article = build(:article, english: "Cat", phonetic: "Tac", language_id: 1, picture: nil)
    assert_not article.save, "Saved the article without a picture"
  end

  it "is saved with :english, :phonetic, :language_id, :picture value" do
    article = build(:article,
                    {
                        english: "Cat",
                        phonetic: "Tac",
                        language_id: 1,
                        picture: Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'picture', 'logo.jpg'))
                    })

    assert article.save, "Saved the article without a phonetic, english value, language_id and picture"
  end

  test 'filters by language' do
    language = create(:language, name: "test_language", id: 2)
    category = create(:category, name: "test_category", id: 1)
    article = create(:article,
                        {
                            english: "Cat",
                            phonetic: "Tac",
                            language_id: 2,
                            category_id:1,
                            picture: Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'picture', 'logo.jpg'))
                        })
    assert_equal(
      [article.id],
      Article.with_language_id(language).map(&:id)
    )
  end

  test 'filters by category' do
    language = create(:language, name: "test_language", id: 1)
    category = create(:category, name: "test_category", id: 2)
    article = create(:article,
                        {
                            english: "Cat",
                            phonetic: "Tac",
                            language_id: 1,
                            category_id:2,
                            picture: Rack::Test::UploadedFile.new(File.join(Rails.root, 'test', 'support', 'picture', 'logo.jpg'))
                        })
    assert_equal(
      [article.id],
      Article.with_category_id(category).map(&:id)
    )
  end

  context "associations" do
    should belong_to(:language)
    should belong_to(:category)

    should have_many(:audios).dependent(:delete_all)
  end

  context "validations" do
    should validate_presence_of(:picture)
  end

  context "delegations" do
    should delegate_method(:name).to(:language).with_prefix(true)
  end
end