require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  tests SitesController

  include Devise::TestHelpers

  setup do
    @org = create(:organization)
    @user = create(:user, organization_id: @org.id)
    @country = create(:country, name: 'Nepal', organization_id: @user.organization.id)
    @user.add_role :admin
    sign_in @user
  end

  def teardown
    Site.delete_all
    Country.delete_all
    User.delete_all
  end

  test "the truth" do
    assert true
  end

  test "index should render correct template and layout" do
    get :index

    assert_template :index
    assert_template layout: "layouts/application"
  end

  test "index should display the correct sites based on search parameter" do
    site1 = create(:site, name: "test_site_1", country_id: @country.id)
    site2 = create(:site, name: "test_site_2", country_id: @country.id)
    site3 = create(:site, name: "test_site_3", country_id: @country.id)

    post :index, search: "test_site"
    assert_template(:index)

    assert_equal "test_site_3", Site.search(assigns(:search)).order('created_at DESC')[0].name
    assert_equal "test_site_2", Site.search(assigns(:search)).order('created_at DESC')[1].name
    assert_equal "test_site_1", Site.search(assigns(:search)).order('created_at DESC')[2].name
  end

  test "index should display the correct sites without search parameter" do
    site1 = create(:site, name: "test_site_1", country_id: @country.id)
    site2 = create(:site, name: "test_site_2", country_id: @country.id)
    site3 = create(:site, name: "test_site_3", country_id: @country.id)

    get :index
    assert_template(:index)

    assert_equal 3, assigns(:sites).count
    assert_equal "test_site_3", assigns(:sites)[0].name
    assert_equal "test_site_2", assigns(:sites)[1].name
    assert_equal "test_site_1", assigns(:sites)[2].name
  end

  test "should render all countries in new for superadmin" do
    @user.add_role :superadmin
    sign_in @user

    @temp_user = create(:user)
    @temp_user.add_role :admin
    country1 = create(:country)
    country2 = create(:country)
    country3 = create(:country)

    get :new

    assert_template(:new)
    assert_equal 4, assigns(:countries).count
  end

  test "should render countries which the user's organization belongs to in new for non superadmin" do
    @user.add_role :admin
    sign_in @user

    @temp_user = create(:user)
    @temp_user.add_role :admin
    country1 = create(:country)
    country2 = create(:country)
    country3 = create(:country)

    get :new

    assert_template(:new)
    assert_equal 1, assigns(:countries).count
  end

  test "should render show page with necessary data" do
    site = create(:site, id: 10, name: "Khatmandu", country_id: @country.id)

    @volunteer1 = create(:user, id: 100, organization_id: @org.id)
    @volunteer1.add_role :volunteer
    @volunteer2 = create(:user, id: 101, organization_id: @org.id)
    @volunteer2.add_role :volunteer

    @contributor1 = create(:user, id: 200, organization_id: @org.id)
    @contributor1.add_role :contributor
    @contributor2 = create(:user, id: 201, organization_id: @org.id)
    @contributor2.add_role :contributor

    get :show, {id: 10}

    assert_equal 2, assigns(:volunteers).count
    assert_equal 2, assigns(:contributors).count
  end

  test "should create site and go to its show page" do
    assert_difference('Site.count') do
      post :create, { site: {name: 'Khatmandu', country_id: @country.id} }
    end

    assert_equal "Site successfully created.", flash[:notice]
    assert_redirected_to site_path(assigns(:site))
  end

  test "should not create site without its name for non superadmin" do
    @user.add_role :admin
    sign_in @user

    @temp_user = create(:user)
    @temp_user.add_role :admin
    country1 = create(:country)
    country2 = create(:country)
    country3 = create(:country)

    assert_no_difference('Site.count') do
      post :create, site: {name: nil, country_id: @country.id }
    end

    assert_equal "Sorry, failed to create site due to errors.", flash[:error]
    assert_template(:new)
    assert_equal 1, assigns(:countries).count
  end

  test "should not create site without its name for superadmin" do
    @user.add_role :superadmin
    sign_in @user

    @temp_user = create(:user)
    @temp_user.add_role :admin
    country1 = create(:country)
    country2 = create(:country)
    country3 = create(:country)

    assert_no_difference('Site.count') do
      post :create, site: {name: nil, country_id: @country.id }
    end

    assert_equal "Sorry, failed to create site due to errors.", flash[:error]
    assert_template(:new)
    assert_equal 4, assigns(:countries).count
  end

  test "should not create a duplicate site associated with the same country for non superadmin" do
    @user.add_role :admin
    sign_in @user

    @temp_user = create(:user)
    @temp_user.add_role :admin
    country1 = create(:country)
    country2 = create(:country)
    country3 = create(:country)

    assert_difference('Site.count', 1) do
      2.times {
        post :create, site: {name: "Kathmandu", country_id: @country.id }
      }
    end

    assert_equal "Sorry, failed to create site due to errors.", flash[:error]
    assert_template(:new)
    assert_equal 1, assigns(:countries).count
  end

  test "should not create a duplicate site associated with the same country for superadmin" do
    @user.add_role :superadmin
    sign_in @user

    @temp_user = create(:user)
    @temp_user.add_role :admin
    country1 = create(:country)
    country2 = create(:country)
    country3 = create(:country)

    assert_difference('Site.count', 1) do
      2.times {
        post :create, site: {name: "Kathmandu", country_id: @country.id }
      }
    end

    assert_equal "Sorry, failed to create site due to errors.", flash[:error]
    assert_template(:new)
    assert_equal 4, assigns(:countries).count
  end

  test "should render all countries in edit for superadmin" do
    @user.add_role :superadmin
    sign_in @user

    @temp_user = create(:user)
    @temp_user.add_role :admin
    country1 = create(:country)
    country2 = create(:country)
    country3 = create(:country)

    site = create(:site, id: 10, name: "Khatmandu", country_id: @country.id)
    get :edit, {id: 10}

    assert_template(:edit)
    assert_equal 4, assigns(:countries).count
  end

  test "should render countries which the user's organization belongs to in edit for non superadmin" do
    @user.add_role :admin
    sign_in @user

    @temp_user = create(:user)
    @temp_user.add_role :admin
    country1 = create(:country)
    country2 = create(:country)
    country3 = create(:country)

    site = create(:site, id: 10, name: "Khatmandu", country_id: @country.id)
    get :edit, {id: 10}

    assert_template(:edit)
    assert_equal 1, assigns(:countries).count
  end

  test "should update user and redirect to show page" do
    site1 = create(:site, id: 1, name: "Khatmandu", country_id: @country.id)

    put :update, { id: site1.id, site: {name: "Khaatmaandu"} }

    assert_equal "Khaatmaandu", assigns(:site).name
    assert_redirected_to site_path(assigns(:site))
  end

  test "should not update without site name and country id" do
    site1 = create(:site, name: "Khatmandu", country_id: @country.id)

    get :edit, { id: site1.id }
    put :update, { id: site1.id, site: {name: nil, country_id: nil} }

    assert_equal "Sorry, failed to update site due to errors.", flash[:error]
    assert_template(:edit)
  end

  test "should not update with duplicate site name in same country" do
    site1 = create(:site, id: 1, name: "Khatmandu", country_id: @country.id)
    site2 = create(:site, id: 2, name: "Manilla", country_id: @country.id)

    get :edit, { id: site2.id }
    put :update, {id: site2.id, site: {name: "Khatmandu"}}

    assert_equal "Sorry, failed to update site due to errors.", flash[:error]
    assert_template(:edit)
  end

  test "should add role as volunteer" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    site = create(:site, id: 1, name: "Khatmandu", country_id: @country.id)

    @volunteer1 = create(:user, organization_id: @org.id)
    post :add_role, { username: @volunteer1.username, site_id: site.id, act: :volunteer }
    assert_equal "Volunteer successfully added.", flash[:notice]

    @volunteer2 = create(:user, organization_id: @org.id)
    post :add_role, { username: @volunteer2.username, site_id: site.id, act: :volunteer }
    assert_equal "Volunteer successfully added.", flash[:notice]
  end

  test "should remove role as volunteer" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    site = create(:site, id: 1, name: "Khatmandu", country_id: @country.id)

    @volunteer1 = create(:user, organization_id: @org.id)
    post :add_role, { username: @volunteer1.username, site_id: site.id, act: :volunteer }
    assert_equal "Volunteer successfully added.", flash[:notice]

    post :remove_role, { username: @volunteer1.username, site_id: site.id, act: :volunteer }
    assert_equal "Volunteer successfully deleted.", flash[:notice]

    @volunteer2 = create(:user, organization_id: @org.id)
    post :add_role, { username: @volunteer2.username, site_id: site.id, act: :volunteer }
    assert_equal "Volunteer successfully added.", flash[:notice]

    post :remove_role, { user_id: @volunteer2.id, site_id: site.id, act: :volunteer }
    assert_equal "Volunteer successfully deleted.", flash[:notice]
  end

  test "should add role as contributor" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    site = create(:site, id: 1, name: "Khatmandu", country_id: @country.id)

    @contributor1 = create(:user, organization_id: @org.id)
    post :add_role, { username: @contributor1.username, site_id: site.id, act: :contributor }
    assert_equal "Contributor successfully added.", flash[:notice]

    @contributor2 = create(:user, organization_id: @org.id)
    post :add_role, { username: @contributor2.username, site_id: site.id, act: :contributor }
    assert_equal "Contributor successfully added.", flash[:notice]
  end

  test "should remove role as contributor" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    site = create(:site, id: 1, name: "Khatmandu", country_id: @country.id)

    @contributor1 = create(:user, organization_id: @org.id)
    post :add_role, { username: @contributor1.username, site_id: site.id, act: :contributor }
    assert_equal "Contributor successfully added.", flash[:notice]

    post :remove_role, { username: @contributor1.username, site_id: site.id, act: :contributor }
    assert_equal "Contributor successfully deleted.", flash[:notice]

    @contributor2 = create(:user, organization_id: @org.id)
    post :add_role, { username: @contributor2.username, site_id: site.id, act: :contributor }
    assert_equal "Contributor successfully added.", flash[:notice]

    post :remove_role, { user_id: @contributor2.id, site_id: site.id, act: :contributor }
    assert_equal "Contributor successfully deleted.", flash[:notice]
  end

  test "should not add volunteer/contributor for non existent user" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    site = create(:site, id: 1, name: "Khatmandu", country_id: @country.id)

    post :add_role, { username: "dummy", site_id: site.id, act: :volunteer }
    assert_equal "User doesn't exist.", flash[:error]
  end

  test "should not add volunteer/contributor without volunteer action" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    site = create(:site, id: 1, name: "Khatmandu", country_id: @country.id)

    post :add_role, { username: "dummy", site_id: site.id, act: nil }
    assert_equal "Action not specified.", flash[:error]
  end

  test "should throw error when removing a non existing volunteer for a site" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    site = create(:site, id: 1, name: "Khatmandu", country_id: @country.id)

    @volunteer1 = create(:user, organization_id: @org.id)
    post :remove_role, { username: @volunteer1.username, site_id: site.id, act: :volunteer }
    assert_equal "User not a volunteer for this site.", flash[:error]

    @volunteer2 = create(:user, organization_id: @org.id)
    post :remove_role, { user_id: @volunteer2.id, site_id: site.id, act: :volunteer }
    assert_equal "User not a volunteer for this site.", flash[:error]
  end

  test "should throw error when removing a non existing contributor for a site" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    site = create(:site, id: 1, name: "Khatmandu", country_id: @country.id)

    @contributor1 = create(:user, organization_id: @org.id)
    post :remove_role, { username: @contributor1.username, site_id: site.id, act: :contributor }
    assert_equal "User not a contributor for this site.", flash[:error]

    @contributor2 = create(:user, organization_id: @org.id)
    post :remove_role, { user_id: @contributor2.id, site_id: site.id, act: :contributor }
    assert_equal "User not a contributor for this site.", flash[:error]
  end

  test "should delete site along with all volunteers and contributors under it" do
    site = create(:site, id: 10, name: "Khatmandu", country_id: @country.id)

    @volunteer1 = create(:user, id: 100, organization_id: @org.id)
    @volunteer1.add_role :volunteer, site
    @volunteer2 = create(:user, id: 101, organization_id: @org.id)
    @volunteer2.add_role :volunteer, site

    @contributor1 = create(:user, id: 200, organization_id: @org.id)
    @contributor1.add_role :contributor, site
    @contributor2 = create(:user, id: 201, organization_id: @org.id)
    @contributor2.add_role :contributor, site

    assert_difference('Site.count',-1) do
      delete :destroy, {id: site.id}
      assert_response :redirect
    end
    
    assert_equal "Site has been deleted.", flash[:notice]
    assert_nil Site.find_by_id(site.id)

    # CHECK IF SITE IS DELETED
    assert_equal Site.find_by_id(10), nil
    # CHECK IF VOLUNTEERS ARE DELETED
    assert_equal User.find_by_id(100), nil
    assert_equal User.find_by_id(101), nil
    # CHECK IF CONTRIBUTORS ARE DELETED
    assert_equal User.find_by_id(200), nil
    assert_equal User.find_by_id(201), nil

    assert_not_nil Country.find_by_id(@country.id)
  end
end
