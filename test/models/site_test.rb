# == Schema Information
#
# Table name: sites
#
#  id         :integer          not null, primary key
#  name       :string
#  country_id :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class SiteTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "should not save site without its field name" do
    site = Site.new
    assert_not site.save, "Saved the site without its name"
  end

  test "should not save site with same field name for same country" do
    site1 = create(:site, country_id: 1, name: "site_name")
    site2 = build(:site, country_id: 1, name: "site_name")
    assert_not site2.save, "Saved site with same name for same country"
  end

  test "should save site with same field name for different countries" do
    site1 = create(:site, country_id: 1, name: "site_name")
    site2 = build(:site, country_id: 2, name: "site_name")
    assert site2.save, "Couldn't save site with same name for different countries"
  end

  test "check if site name present in search" do
  	# POPULATING DATABASE FROM FACTORY WITH OVERRIDE, TO VERIFY SEARCH
  	site1 = create(:site, name: "test_site_1")
  	site2 = create(:site, name: "test_site_2")
  	site3 = create(:site, name: "test_site_3")

  	assert_equal Site.search("test_site_1")[0].name, "test_site_1", "Site Search not returning correct object"
  end

  context "associations" do
  	should belong_to(:country)
  end

  context "validations" do
  	should validate_presence_of(:name)
  	should validate_uniqueness_of(:name).scoped_to(:country_id).case_insensitive
  end
end
