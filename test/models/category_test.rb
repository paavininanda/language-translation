# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "should not save category without its field name" do
    category = Category.new
    assert_not category.save, "Saved the category without its name"
  end

  test "should save category with its field name" do
    category = Category.new
    category.name = "test_category"
    assert category.save, "Couldn't save the category with its name"
  end

  test "check if category present in search" do
  	# POPULATING DATABASE FROM FACTORY WITH OVERRIDE, TO VERIFY SEARCH
  	category1 = create(:category, name: "test_category_1")
  	category2 = create(:category, name: "test_category_2")
  	category3 = create(:category, name: "test_category_3")

  	assert_equal Category.search("test_category_1")[0].name, "test_category_1", "Category Search not returning correct object"
  end

  test "check if all category options render" do
  	# POPULATING DATABASE FROM FACTORY WITH OVERRIDE, TO VERIFY SEARCH
  	category1 = create(:category, name: "test_category_1")
  	category2 = create(:category, name: "test_category_2")
  	category3 = create(:category, name: "test_category_3")

  	assert_equal Category.options_for_select.count, "3".to_i, "All category options not rendered"
  end

  test "should not save category with same name" do
    category1 = create(:category, name: "test_category_1")
    category2 = build(:category, name: "test_category_1")

    assert_not category2.save, "Category name already exists."
  end

  context "associations" do
    should have_many(:articles)
  end

  context "validations" do
  	should validate_presence_of(:name)
  	should validate_uniqueness_of(:name).case_insensitive
  end
end