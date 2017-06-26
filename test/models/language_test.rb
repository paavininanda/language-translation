# == Schema Information
#
# Table name: languages
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class LanguageTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "should not save language without its field name" do
    language = Language.new
    assert_not language.save, "Saved the language without its name"
  end

  test "check if language present in search" do
  	# POPULATING DATABASE FROM FACTORY WITH OVERRIDE, TO VERIFY SEARCH
  	language1 = create(:language, name: "test_language_1")
  	language2 = create(:language, name: "test_language_2")
  	language3 = create(:language, name: "test_language_3")

  	assert_equal Language.search("test_language_1")[0].name, "test_language_1", "Language Search not returning correct object"
  end

  test "check if all language options render" do
  	# POPULATING DATABASE FROM FACTORY WITH OVERRIDE, TO VERIFY SEARCH
  	language1 = create(:language, name: "test_language_1")
  	language2 = create(:language, name: "test_language_2")
  	language3 = create(:language, name: "test_language_3")

  	assert_equal Language.options_for_select.count, "3".to_i, "All language options not rendered"
  end

  test "should not save language with same name" do
    language1 = create(:language, name: "test_language_1")
    language2 = build(:language, name: "test_language_1")

    assert_not language2.save, "Language name already exists."
  end

  context "validations" do
  	should validate_presence_of(:name)
  	should validate_uniqueness_of(:name).case_insensitive
  end
end