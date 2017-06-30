require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  test "what superadmin can" do
    # Creating a test user
    organization = create(:organization, id: 1, name: "test_organization_1")
    superadmin = create(:user, id: 1, email: "test_user_1@gamil.com", username: "testuser1", first_name: "Test", last_name: "User1", organization_id: 1, location: "test_location_1", login_approval_at: 2.weeks.ago)
    
    # Assigning the user superadmin role
    superadmin.add_role :superadmin
  	ability = Ability.new(superadmin)

  	# Superadmin can do everything
  	assert ability.can?(:manage, :all), "Superadmin cannot manage everything"
  	# Superadmin also has access to admin console via http://the_site_address/admin
  	assert ability.can?(:read, ActiveAdmin::Page, name: "Dashboard", namespace_name: :superadmin), "Superadmin cannot access the ActiveAdmin interface via http://the_site_address/admin"
	end

  test "what admin can" do
    # Creating a test user
    organization = create(:organization, id: 1, name: "test_organization_1")
    admin = create(:user, id: 1, email: "test_user_1@gamil.com", username: "testuser1", first_name: "Test", last_name: "User1", organization_id: 1, location: "test_location_1", login_approval_at: 2.weeks.ago)

    # Assigning the user admin role
    admin.add_role :admin
  	ability = Ability.new(admin)
  	
  	# Admin can manage Language, Category and Articles freely, without restrictions
  	assert ability.can?(:manage, Language.new), "Admin cannot manage Language"
  	assert ability.can?(:manage, Category.new), "Admin cannot manage Category"
  	assert ability.can?(:manage, Article.new), "Admin cannot manage Article"
  	# Admin can only manage the Countries, Sites, and Users that belong to their own organization
  	assert ability.can?(:read, Organization.new(:id => admin.organization.id)), "Admin cannot read their Organization"
  	assert ability.can?(:update, Organization.new(:id => admin.organization.id)), "Admin cannot update their Organization"
  	assert ability.can?(:manage, Country.new(:organization_id => admin.organization.id)), "Admin cannot manage the Country of their Organization"
  	assert ability.can?(:manage, User.new(:organization_id => admin.organization.id)), "Admin cannot manage User in their Organization"
  	# Admin can read and update the organization site they belong to
  	assert ability.can?(:new, Site.new), "Admin cannot create their Site"
  	assert ability.can?(:manage, Site, country_id: admin.organization.countries.map { |a| a.id }), "Admin cannot update the site of the organization they belong to."
	end

  test "what volunteers can" do
    # Creating a test user
    organization = create(:organization, id: 1, name: "test_organization_1")
    volunteer = create(:user, id: 1, email: "test_user_1@gamil.com", username: "testuser1", first_name: "Test", last_name: "User1", organization_id: 1, location: "test_location_1", login_approval_at: 2.weeks.ago)
    
    # Assigning the user volunteer role
    volunteer.add_role :volunteer
  	ability = Ability.new(volunteer)

  	# Volunteers can only read Language and Category but can manage Articles
  	assert ability.can?(:read, Language.new), "Volunteer cannot read Language"
  	assert ability.can?(:read, Category.new), "Volunteer cannot read Category"
  	assert ability.can?(:manage, Article.new), "Volunteer cannot manage Article"
  	# Volunteers are allowed to read other users
  	assert ability.can?(:read, User.new(:organization_id => volunteer.organization.id)), "Volunteer cannot read the volunteer details of the organization they belong to"
  	# Volunteers are allowed to manage the contributors that belong to the same organization
  	assert ability.can?(:manage, User, :organization_id => volunteer.organization.id, :id => User.with_any_role({name: :contributor, resource: :any}, :guest).map { |a| a.id } ), "Volunteer can't manage contributor or guest of same organization"
  	# Volunteers can read and update the Site they belong to
  	assert ability.can?(:read, Site, :id => Site.with_role(:volunteer, @user).map { |a| a.id } ), "Volunteer cannot read his site"
  	assert ability.can?(:update, Site, :id => Site.with_role(:volunteer, @user).map { |a| a.id } ), "Volunteer cannot read his site"
	end

  test "what contributor can and cannot" do
    # Creating a test user
    organization = create(:organization, id: 1, name: "test_organization_1")
    contributor = create(:user, id: 1, email: "test_user_1@gamil.com", username: "testuser1", first_name: "Test", last_name: "User1", organization_id: 1, location: "test_location_1", login_approval_at: 2.weeks.ago)

    # Assigning the user contributor role
    contributor.add_role :contributor
  	ability = Ability.new(contributor)

  	# Contributors can only read, create, and update Articles
  	assert ability.can?(:read, Article.new), "Contributor cannot read Articles"
  	assert ability.can?(:create, Article.new), "Contributor cannot create Articles"
  	assert ability.can?(:update, Article.new), "Contributor cannot update Articles"
  	assert ability.cannot?(:destroy, Article.new), "Contributor can destroy Articles"
	end

	test "what others can and cannot" do
    # Creating a test user
    organization = create(:organization, id: 1, name: "test_organization_1")
    others = create(:user, id: 1, email: "test_user_1@gamil.com", username: "testuser1", first_name: "Test", last_name: "User1", organization_id: 1, location: "test_location_1", login_approval_at: 2.weeks.ago)

    # Guest users have no special ability
    ability = Ability.new(others)

    # Guest users are only allowed to read Articles
    assert ability.can?(:read, Article.new), "Others cannot read Articles"
  	assert ability.cannot?(:create, Article.new), "Others cannot create Articles"
  	assert ability.cannot?(:update, Article.new), "Others cannot update Articles"
  	assert ability.cannot?(:destroy, Article.new), "Others can destroy Articles"
	end
end