require "test_helper"

class UsersControllerTest < ActionController::TestCase
  tests UsersController

  def setup
    @org = create(:organization)
    @user = create(:user, organization_id: @org.id)
    @user.add_role :admin

    @language = create(:language, name: 'Chuukese')

    sign_in @user
  end

  def teardown
    sign_out(@user)
    
    User.delete_all
  end

  it "gets index" do
    get :index

    assert_equal 200, response.status
    value(assigns(:users)).wont_be :nil?
  end

  it "shows user" do
    @contributor = create(:user, organization_id: @org.id)
    @contributor.add_role :contributor

    get :show, id: @contributor

    assert_equal 200, response.status
    assert assigns(:user).has_role?(:contributor)
  end

  it "gets edit" do
    get :edit, id: @user
    value(response).must_be :success?
  end

  it "updates user" do
    put :update, id: @user, user: { first_name: "Watson", last_name: "Edwards" }

    must_redirect_to user_path(@user)
  end

  it "destroys user" do
    @contributor = create(:user, organization_id: @org.id)
    @contributor.add_role :contributor
 
    expect {
      delete :destroy, id: @contributor
    }.must_change "User.count", -1

    must_redirect_to users_path
  end

  it "gets new" do
    get :new

    assert_equal 200, response.status
  end

  it "creates user" do
    post :create, user: { first_name: "Watson", last_name: "Edwards", username: "watson", email: "watson@plt.com", password: "ONo999ngoeHIj", no_invitation: 0}

    send_email = ActionMailer::Base.deliveries.last

    assert_equal "Invitation instructions", send_email.subject
    assert_equal "watson@plt.com", send_email.to[0]
  end

end
