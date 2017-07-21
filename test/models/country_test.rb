# == Schema Information
#
# Table name: countries
#
#  id              :integer          not null, primary key
#  name            :string
#  created_at      :datetime
#  updated_at      :datetime
#  organization_id :integer
#  user_id         :integer
#

require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "should not save country without its field name" do
    country = Country.new
    assert_not country.save, "Saved the country without its name"
  end

  test "should not save country without its field organization_id" do
    country = Country.new
    country.name = "India"
    assert_not country.save, "Saved the country without organization_id"
  end

  test "should save country with name and organization_id" do
    organization = create(:organization, id: 1, name: "test_organization")
    country = build(:country, name: "test_country", organization_id: 1)
    assert country.save, "Couldn't save the country with name and organization_id"
  end

  test "should not save country with same field name for same organization" do
    organization = create(:organization, id: 1, name: "test_organization")

    country1 = create(:country, organization_id: 1, name: "country_name")
    country2 = build(:country, organization_id: 1, name: "country_name")
    
    assert_not country2.save, "Saved country with same name for same organization"
  end

  test "should save country with same field name for different organizations" do
    organization1 = create(:organization, id: 1, name: "test_organization_1")
    organization2 = create(:organization, id: 2, name: "test_organization_2")

    country1 = create(:country, organization_id: 1, name: "country_name")
    country2 = build(:country, organization_id: 2, name: "country_name")
    assert country2.save, "Couldn't save country with same name for different organization"
  end

  test "check if country name present in search" do
  	# POPULATING DATABASE FROM FACTORY WITH OVERRIDE, TO VERIFY SEARCH
  	country1 = create(:country, name: "test_country_1")
  	country2 = create(:country, name: "test_country_2")
  	country3 = create(:country, name: "test_country_3")

  	assert_equal Country.search("test_country_1")[0].name, "test_country_1", "Country Search not returning correct object"
  end

	context "associations" do
  	should belong_to(:organization)
  	should belong_to(:user)

  	should have_many(:sites).dependent(:destroy)
  end

  context "validations" do
  	should validate_presence_of(:name)
  	should validate_uniqueness_of(:name).scoped_to(:organization_id).case_insensitive
	end
end