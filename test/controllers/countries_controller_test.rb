require 'test_helper'

class CountriesControllerTest < ActionController::TestCase
  tests CountriesController

  include Devise::TestHelpers

  test "the truth" do
    assert true
  end

  setup do
    @organization = create(:organization, name: "test_organization")
    @user = create(:user, organization_id: @organization.id)
    @user.add_role :admin
    sign_in @user
  end

  def teardown
    Country.delete_all
    User.delete_all
  end

  test "index should render correct template and layout" do
    get :index
    assert_template :index
    assert_template layout: "layouts/application"
  end

  test "index should display correct items and order for superadmin on search parameter input" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    country1 = create(:country, name: "test_country_1", user_id: @superadmin.id)
    country2 = create(:country, name: "test_country_2", user_id: @superadmin.id)
    country3 = create(:country, name: "test_country_3", user_id: @superadmin.id)
    
    post :index, search: "test_country"

    assert_equal "test_country_3", Country.search(assigns(:search)).order('created_at DESC')[0].name
    assert_equal "test_country_2", Country.search(assigns(:search)).order('created_at DESC')[1].name
    assert_equal "test_country_1", Country.search(assigns(:search)).order('created_at DESC')[2].name
  end

  test "index should display correct items and order for superadmin without search parameter input" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    country1 = create(:country, name: "test_country_1", user_id: @superadmin.id)
    country2 = create(:country, name: "test_country_2", user_id: @superadmin.id)
    country3 = create(:country, name: "test_country_3", user_id: @superadmin.id)
    country4 = create(:country, name: "Dummy Country", user_id: @superadmin.id)

    get :index, search: nil

    assert_equal "Dummy Country", Country.all.order('created_at DESC')[0].name
    assert_equal "test_country_3", Country.all.order('created_at DESC')[1].name
    assert_equal "test_country_2", Country.all.order('created_at DESC')[2].name
    assert_equal "test_country_1", Country.all.order('created_at DESC')[3].name
  end

  test "index should display correct items and order for other users on search parameter input" do
    country1 = create(:country, name: "test_country_1", user_id: @user.id)
    country2 = create(:country, name: "test_country_2", user_id: @user.id)
    country3 = create(:country, name: "test_country_3", user_id: @user.id)
    
    post :index, search: "test_country"

    assert_equal "test_country_3", Country.search(assigns(:search)).order('created_at DESC')[0].name
    assert_equal "test_country_2", Country.search(assigns(:search)).order('created_at DESC')[1].name
    assert_equal "test_country_1", Country.search(assigns(:search)).order('created_at DESC')[2].name
  end

  test "index should display correct items and order for other users without search parameter input" do
    @organization1 = create(:organization, name: "test_organization_1")
    @user = create(:user, organization_id: @organization1.id)
    @user.add_role :volunteer

    country1 = create(:country, name: "test_country_1", user_id: @user.id, organization_id: @organization1.id)
    country2 = create(:country, name: "test_country_2", user_id: @user.id, organization_id: @organization1.id)
    country3 = create(:country, name: "test_country_3", user_id: @user.id, organization_id: @organization1.id)

    assert_equal "test_country_3", @user.organization.countries.order('created_at DESC')[0].name
    assert_equal "test_country_2", @user.organization.countries.order('created_at DESC')[1].name
    assert_equal "test_country_1", @user.organization.countries.order('created_at DESC')[2].name
  end

  test "should render new country input page" do
    get :new

    assert_template :new
    assert_template layout: "layouts/application"
  end

  test "should create country and go to its show page" do
    assert_difference('Country.count') do
      post :create, country: {name: 'Albania'}
    end
    assert_equal "Country successfully created.", flash[:notice]
    assert_redirected_to country_path(assigns(:country))
  end

  test "should not create country without its name" do
    assert_no_difference('Country.count') do
      post :create, country: {name: nil}
    end
    assert_equal "Sorry, failed to create country due to errors.", flash[:error]
    assert_template(:new)
  end

  test "should not create a duplicate country associated with same organization" do
    organization1 = create(:organization, id: 1, name: "test_organization_1")

    assert_difference('Country.count', 0) do
      2.times {
        post :create, country: {name: 'Albania', organization_id: organization1.id}
      }
    end
  end

  test "should render show page on requested country show method" do
    organization1 = create(:organization, id: 1, name: "test_organization_1")
    country = create(:country, name: "Albania")

    get :show, {id: country.id, country: {name: "Albania", organization_id: organization1.id } }

    assert_equal "Albania", assigns(:country).name
  end

  test "should update country name in an organization" do
    country = Country.create!({name: 'Azerbaijan', organization_id: @user.organization.id })

    put :update, {id: country.id, country: {name: "Nepal"}}

    assert_equal "Nepal", assigns(:country).name
    assert_equal "Country successfully updated.", flash[:notice]
    assert_redirected_to country_path(assigns(:country))
  end

  test "should not update without country name" do
    country = Country.create!({name: 'Azerbaijan', organization_id: @user.organization.id })

    put :update, {id: country.id, country: {name: ""} }

    assert_empty assigns(:country).name
    assert_equal "Sorry, failed to update country due to errors.", flash[:error]
    assert_template(:edit)
  end

  test "should not update country name with duplicate entry in same organization" do
    country1 = Country.create!({name: 'Azerbaijan', organization_id: @user.organization.id })
    put :update, {id: country1.id, country: {name: "Nepal"}}
    assert_equal "Nepal", assigns(:country).name

    country2 = Country.create!({name: 'Azerbaijan', organization_id: @user.organization.id })
    put :update, {id: country2.id, country: {name: "Nepal"}}

    assert_equal "Sorry, failed to update country due to errors.", flash[:error]
    assert_template(:edit)
  end

  test "should delete country along with all sites under that country" do
    country = Country.create!({name: 'Azerbaijan', organization_id: @user.organization.id })
    site = Site.create!({country_id: country.id, name:'Leh'})

    assert_difference('Country.count',-1) do
      puts Country.count
      delete :destroy, id: country.id
      assert_response :redirect
      puts Country.count
    end

    assert_nil Country.find_by_id(country.id)
    assert_nil Site.find_by_country_id(country.id)
    assert_nil Site.find_by_id(site.id)
  end

end
