# == Schema Information
#
# Table name: organizations
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class OrganizationTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "should not save organization without its field name" do
    organization = Organization.new
    assert_not organization.save, "Saved the organization without its name"
  end

  test "should save organization with name" do
    organization = build(:organization, name: "test_organization")
    assert organization.save, "Couldn't save the organization with name"
  end

  test "should not save organization with same field name for same organization" do
    organization1 = create(:organization, name: "organization_name")
    organization2 = build(:organization, name: "organization_name")
    
    assert_not organization2.save, "Saved organization with existing name"
  end

  test "check if organization name present in search" do
  	# POPULATING DATABASE FROM FACTORY WITH OVERRIDE, TO VERIFY SEARCH
  	organization1 = create(:organization, name: "test_organization_1")
  	organization2 = create(:organization, name: "test_organization_2")
  	organization3 = create(:organization, name: "test_organization_3")

  	assert_equal Organization.search("test_organization_1")[0].name, "test_organization_1", "Organization Search not returning correct object"
  end

	context "associations" do
  	should have_many(:users).dependent(:delete_all)
  	should have_many(:countries)
  end

  context "validations" do
  	should validate_presence_of(:name)
  	should validate_uniqueness_of(:name).case_insensitive
	end
end