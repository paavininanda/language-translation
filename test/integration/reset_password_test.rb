require 'test_helper'

class ResetPasswordTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
    @user.add_role :admin
  end

  test "reset user's password" do 
    old_password = @user.encrypted_password

    assert_difference('ActionMailer::Base.deliveries.count', 1) do
      post user_password_path, user: {email: @user.email}
      assert_redirected_to new_user_session_path
    end

    reset_password_token  = @user.send_reset_password_instructions

    @user.reload
    assert_not_nil @user.reset_password_token

    put "/reset_password", user: {
      reset_password_token: "bad reset token", 
      password: "new-password", 
      password_confirmation: "new-password",
    }

    assert_match "error", response.body
    assert_equal @user.encrypted_password, old_password

    put "/reset_password", user: {
      reset_password_token: reset_password_token, 
      password: "new-password", 
      password_confirmation: "new-password",
    }

    assert_redirected_to root_path

    @user.reload
    assert_not_equal(@user.encrypted_password, old_password)
  end
end