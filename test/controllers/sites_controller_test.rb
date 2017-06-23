require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = create(:user)
    @user.add_role :admin
    sign_in @user
  end

  def teardown
    User.delete_all
    Site.delete_all
  end

  test "the truth" do
    assert true
  end

  test "index should render correct template and layout" do
    get :index

    assert_template :index
    assert_template layout: "layouts/application"
  end

  test "should create site and go to its show page" do
    country = Country.create({name: 'Azerbaijan', organization_id: @user.organization.id })

    assert_difference('Site.count') do
      post :create, site: {name: 'Devoll', country_id: country.id}
    end
    assert_redirected_to site_path(assigns(:site))
  end

  test "should not create site without its name" do
    country = Country.create({name: 'Azerbaijan', organization_id: @user.organization.id })

    assert_no_difference('Site.count') do
      post :create, site: {name: nil, country_id: country.id }
    end
  end

  test "should not create a duplicate site associated with the same country" do
    country = Country.create({name: 'Azerbaijan', organization_id: @user.organization.id })
    assert_difference('Site.count', 1) do
      2.times {
        post :create, site: {name: "Kathmandu", country_id: country.id }
      }
    end
  end

  test "should delete site along with all volunteers and contributors under it" do
    country = Country.create({name: 'Azerbaijan', organization_id: @user.organization.id })
    site = Site.create!({country_id: country.id, name: 'Leh'})

    #volunteer = Volunteer.create({site_id: site.id, vname: 'Saumya'})
    #contributor = Contributor.create!({site_id: site.id, name: 'Dipika'})

    assert_difference('Site.count',-1) do
      delete :destroy, id: site.id
      assert_response :redirect
    end

    assert_nil Site.find_by_id(site.id)

    #assert_nil Volunteer.find_by_id(volunteer.id)
    #assert_nil Volunteer.find_by_site_id(site.id)
    #assert_nil Contributor.find_by_id(contributor.id)
    #assert_nil Contributor.find_by_site_id(site.id)

    assert_not_nil Country.find_by_id(country.id)
  end

end
