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

  test "gets index" do
    get :index

    assert_equal 200, response.status
    value(assigns(:users)).wont_be :nil?
  end

  test "index should display the correct users based on search parameter" do
    organization1 = create(:organization, id: 1, name: "test_organization_1")

    user1 = create(:user, email: "test_user_1@gamil.com", username: "testuser1", first_name: "Test", last_name: "User1", organization_id: 1, location: "test_location_1", login_approval_at: 2.weeks.ago)
    user2 = create(:user, email: "test_user_2@gamil.com", username: "testuser2", first_name: "Test", last_name: "User2", organization_id: 1, location: "test_location_2", login_approval_at: 2.weeks.ago)
    user3 = create(:user, email: "test_user_3@gamil.com", username: "testuser3", first_name: "Test", last_name: "User3", organization_id: 1, location: "test_location_3", login_approval_at: 2.weeks.ago)

    post :index, search: "test_location_1"
    assert_equal 200, response.status
    value(assigns(:users)).wont_be :nil?

    assert_equal "testuser3", User.search(assigns(:search)).order('created_at DESC')[0].username
    assert_equal "testuser2", User.search(assigns(:search)).order('created_at DESC')[1].username
    assert_equal "testuser1", User.search(assigns(:search)).order('created_at DESC')[2].username
  end

  test "index should display the correct users based without search parameter" do
    organization1 = create(:organization, id: 1, name: "test_organization_1")

    user0 = create(:user, email: "test_user_0@gamil.com", username: "testuser0", first_name: "Test", last_name: "User0", organization_id: 1, location: "test_location_0", login_approval_at: 2.weeks.ago)
    user1 = create(:user, email: "test_user_1@gamil.com", username: "testuser1", first_name: "Test", last_name: "User1", organization_id: 1, location: "test_location_1", login_approval_at: 2.weeks.ago)
    user2 = create(:user, email: "test_user_2@gamil.com", username: "testuser2", first_name: "Test", last_name: "User2", organization_id: 1, location: "test_location_2", login_approval_at: 2.weeks.ago)
    user3 = create(:user, email: "test_user_3@gamil.com", username: "testuser3", first_name: "Test", last_name: "User3", organization_id: 1, location: "test_location_3", login_approval_at: 2.weeks.ago)

    user0.add_role :contributor
    user1.add_role :admin
    user2.add_role :volunteer
    user3.add_role :superadmin

    get :index
    assert_equal 200, response.status
    value(assigns(:users)).wont_be :nil?

    assert_equal "testuser3", User.order('created_at DESC')[0].username
    assert_equal "testuser2", User.order('created_at DESC')[1].username
    assert_equal "testuser1", User.order('created_at DESC')[2].username
  end

  test "shows user" do
    @contributor = create(:user, organization_id: @org.id)
    @contributor.add_role :contributor

    get :show, id: @contributor

    assert_equal 200, response.status
    assert assigns(:user).has_role?(:contributor)
  end

  test "gets edit" do
    get :edit, id: @user
    value(response).must_be :success?
  end

  test "updates user" do
    put :update, id: @user, user: { first_name: "Watson", last_name: "Edwards" }

    must_redirect_to user_path(@user)
  end

  test "destroys user" do
    @contributor = create(:user, organization_id: @org.id)
    @contributor.add_role :contributor
 
    expect {
      delete :destroy, id: @contributor
    }.must_change "User.count", -1

    must_redirect_to users_path
  end

  test "gets new" do
    get :new

    assert_equal 200, response.status
  end

  test "creates user" do
    post :create, user: { first_name: "Watson", last_name: "Edwards", username: "watson", email: "watson@plt.com", password: "ONo999ngoeHIj", no_invitation: 0, organization_id: @org.id}

    send_email = ActionMailer::Base.deliveries.last

    assert_equal "Invitation instructions", send_email.subject
    assert_equal "watson@plt.com", send_email.to[0]
  end

  test "should not create user without username" do
    post :create, user: { first_name: "Watson", last_name: "Edwards", username: nil, email: "watson@plt.com", password: "ONo999ngoeHIj", no_invitation: 0, organization_id: @org.id}

    assert_equal "Sorry, failed to create user due to errors.", flash[:error]
    assert_template(:new)
  end

  test "should not create user without firstname" do
    post :create, user: { first_name: nil, last_name: "Edwards", username: "watson", email: "watson@plt.com", password: "ONo999ngoeHIj", no_invitation: 0, organization_id: @org.id}

    assert_equal "Sorry, failed to create user due to errors.", flash[:error]
    assert_template(:new)
  end

  test "should not create user without lastname" do
    post :create, user: { first_name: "Watson", last_name: nil, username: "watson", email: "watson@plt.com", password: "ONo999ngoeHIj", no_invitation: 0, organization_id: @org.id}

    assert_equal "Sorry, failed to create user due to errors.", flash[:error]
    assert_template(:new)
  end

  test "should not create a user with same existing username" do
    assert_difference('User.count', 1) do
      2.times {
        post :create, user: { first_name: "Watson", last_name: "Edwards", username: "watson", email: "watson@plt.com", password: "ONo999ngoeHIj", no_invitation: 0, organization_id: @org.id}
      }
    end

    assert_equal "Sorry, failed to create user due to errors.", flash[:error]
    assert_template(:new)
  end

  test "should update username, firstname, lastname, contact" do
    put :update, {id: @user.id, user: {username: "testuser0", first_name: "fname0", last_name: "lname0", contact: "123123123" } }

    assert_equal "testuser0", assigns(:user).username
    assert_equal "fname0", assigns(:user).first_name
    assert_equal "lname0", assigns(:user).last_name
    assert_equal "123123123", assigns(:user).contact

    assert_equal "User successfully updated.", flash[:notice]
    assert_redirected_to user_path(assigns(:user))
  end

  test "should not update username if not unique" do
    user1 = create(:user, id: 1, first_name: "Watson", last_name: "Edwards", username: "watson", email: "watson@plt.com", password: "ONo999ngoeHIj", no_invitation: 0, organization_id: @org.id)
    user2 = create(:user, id: 2, first_name: "Watson", last_name: "Edwards", username: "whatson", email: "whatson@plt.com", password: "ONo999ngoeHIj", no_invitation: 0, organization_id: @org.id)

    put :update, {id: 2, user: {username: "watson"}}

    assert_equal "Sorry, failed to update user due to errors.", flash[:error]
    assert_template(:edit)
  end

  test "should check if user has avatar" do
    user0 = create(:user)
    assert_match "logo.jpg", user0.avatar_url(user0)

    user1 = create(:user, email: "test_user_1@gmail.com", username: "testuser1", first_name: "Test", last_name: "User1", organization_id: @org.id, location: "test_location_1", login_approval_at: 2.weeks.ago, avatar: nil)
    assert_equal nil, user1.avatar_url(user1)
  end

  test "should approve user if current user superadmin or admin" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    user0 = create(:user)
    post :approve_user, { :user_id => user0.id }
    assert_equal "User has been approved.", flash[:notice]

    sign_out @superadmin

    @admin = create(:user, organization_id: organization1.id)
    @admin.add_role :admin
    sign_in @admin

    user1 = create(:user)
    post :approve_user, { :username => user1.username }
    assert_equal "User has been approved.", flash[:notice]
  end

  test "should not approve user if current user volunteer or contributor" do
    organization1 = create(:organization, name: "test_organization_1")
    @volunteer = create(:user, organization_id: organization1.id)
    @volunteer.add_role :volunteer
    sign_in @volunteer

    user0 = create(:user)
    post :approve_user, { :user_id => user0.id }
    assert_equal "User does not have sufficient permission to perform this action.", flash[:error]

    sign_out @volunteer

    @contributor = create(:user, organization_id: organization1.id)
    @contributor.add_role :contributor
    sign_in @contributor

    user1 = create(:user)
    post :approve_user, { :username => user1.username }
    assert_equal "User does not have sufficient permission to perform this action.", flash[:error]
  end

  test "should not approve user for non existent user" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    user0 = create(:user)
    post :approve_user, { :user_id => nil }
    assert_equal "User not available.", flash[:error]

    sign_out @superadmin

    @admin = create(:user, organization_id: organization1.id)
    @admin.add_role :admin
    sign_in @admin

    user1 = create(:user)
    post :approve_user, { :username => user1.username }
    assert_equal "User not available.", flash[:error]
  end

  test "should disapprove user if current user superadmin or admin" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    user0 = create(:user)
    post :disapprove_user, { :user_id => user0.id }
    assert_equal "User has been disapproved.", flash[:notice]

    sign_out @superadmin

    @admin = create(:user, organization_id: organization1.id)
    @admin.add_role :admin
    sign_in @admin

    user1 = create(:user)
    post :disapprove_user, { :username => user1.username }
    assert_equal "User has been disapproved.", flash[:notice]
  end

  test "should not disapprove user if current user volunteer or contributor" do
    organization1 = create(:organization, name: "test_organization_1")
    @volunteer = create(:user, organization_id: organization1.id)
    @volunteer.add_role :volunteer
    sign_in @volunteer

    user0 = create(:user)
    post :disapprove_user, { :user_id => user0.id }
    assert_equal "User does not have sufficient permission to perform this action.", flash[:error]

    sign_out @volunteer

    @contributor = create(:user, organization_id: organization1.id)
    @contributor.add_role :contributor
    sign_in @contributor

    user1 = create(:user)
    post :disapprove_user, { :username => user1.username }
    assert_equal "User does not have sufficient permission to perform this action.", flash[:error]
  end

  test "should not disapprove user for non existent user" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    user0 = create(:user)
    post :disapprove_user, { :user_id => nil }
    assert_equal "User not available.", flash[:error]

    sign_out @superadmin

    @admin = create(:user, organization_id: organization1.id)
    @admin.add_role :admin
    sign_in @admin

    user1 = create(:user)
    post :disapprove_user, { :username => user1.username }
    assert_equal "User not available.", flash[:error]
  end

  test "should grant admin to user if current user superadmin" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    user0 = create(:user)
    post :grant_admin, { :user_id => user0.id }
    assert_equal "User granted admin permission.", flash[:notice]

    user1 = create(:user)
    post :grant_admin, { :username => user1.username }
    assert_equal "User granted admin permission.", flash[:notice]
  end

  test "should not grant admin to user if current user admin or volunteer or contributor" do
    organization1 = create(:organization, name: "test_organization_1")
    @admin = create(:user, organization_id: organization1.id)
    @admin.add_role :admin
    sign_in @admin

    user1 = create(:user)
    post :grant_admin, { :username => user1.username }
    assert_equal "User does not have sufficient permission to perform this action.", flash[:error]

    @volunteer = create(:user, organization_id: organization1.id)
    @volunteer.add_role :volunteer
    sign_in @volunteer

    user0 = create(:user)
    post :grant_admin, { :user_id => user0.id }
    assert_equal "User does not have sufficient permission to perform this action.", flash[:error]

    sign_out @volunteer

    @contributor = create(:user, organization_id: organization1.id)
    @contributor.add_role :contributor
    sign_in @contributor

    user1 = create(:user)
    post :grant_admin, { :username => user1.username }
    assert_equal "User does not have sufficient permission to perform this action.", flash[:error]
  end

  test "should not grant admin to user for non existent user" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    user0 = create(:user)
    post :disapprove_user, { :user_id => nil }
    assert_equal "User not available.", flash[:error]

    sign_out @superadmin

    @admin = create(:user, organization_id: organization1.id)
    @admin.add_role :admin
    sign_in @admin

    user1 = create(:user)
    post :disapprove_user, { :username => user1.username }
    assert_equal "User not available.", flash[:error]
  end

  test "should revoke admin to user if current user superadmin" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    user0 = create(:user)
    post :revoke_admin, { :user_id => user0.id }
    assert_equal "Admin permissions revoked for user.", flash[:notice]

    user1 = create(:user)
    post :revoke_admin, { :username => user1.username }
    assert_equal "Admin permissions revoked for user.", flash[:notice]
  end

  test "should not revoke admin to user if current user admin or volunteer or contributor" do
    organization1 = create(:organization, name: "test_organization_1")
    @admin = create(:user, organization_id: organization1.id)
    @admin.add_role :admin
    sign_in @admin

    user1 = create(:user)
    post :revoke_admin, { :username => user1.username }
    assert_equal "User does not have sufficient permission to perform this action.", flash[:error]

    @volunteer = create(:user, organization_id: organization1.id)
    @volunteer.add_role :volunteer
    sign_in @volunteer

    user0 = create(:user)
    post :revoke_admin, { :user_id => user0.id }
    assert_equal "User does not have sufficient permission to perform this action.", flash[:error]

    sign_out @volunteer

    @contributor = create(:user, organization_id: organization1.id)
    @contributor.add_role :contributor
    sign_in @contributor

    user1 = create(:user)
    post :revoke_admin, { :username => user1.username }
    assert_equal "User does not have sufficient permission to perform this action.", flash[:error]
  end

  test "should not revoke admin to user for non existent user" do
    organization1 = create(:organization, name: "test_organization_1")
    @superadmin = create(:user, organization_id: organization1.id)
    @superadmin.add_role :superadmin
    sign_in @superadmin

    user0 = create(:user)
    post :revoke_admin, { :user_id => nil }
    assert_equal "User not available.", flash[:error]
  end
end