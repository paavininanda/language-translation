# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default("")
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string
#  last_name              :string
#  username               :string
#  location               :string
#  contact                :string
#  gender                 :string
#  lang                   :string
#  tsv_data               :tsvector
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default(0)
#  authentication_token   :string
#  login_approval_at      :datetime
#  organization_id        :integer
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "the truth" do
    assert true
  end

  setup do
    @organization = create(:organization)
  end

  def teardown
    User.delete_all
    Organization.delete_all
  end

  test "should not save user without its fields username, email, first_name, last_name" do
    user = User.new
    assert_not user.save, "Saved the user without its compulsory fields"
  end

  test "should not save user without its field email" do
    user = User.new
    user.username='Alia'
    user.first_name='Aliaa'
    user.last_name='Bhatt'
    assert_not user.save, "Saved the user without its email"
  end

  test "should not save user without its field username" do
    user = User.new
    user.email='wonook@wonook.me'
    user.first_name='Aliaa'
    user.last_name='Bhatt'
    assert_not user.save, "Saved the user without its username"
  end

  test "should not save user without its field first_name" do
    user = User.new
    user.email='wonook@wonook.me'
    user.username='Alia'
    user.last_name='Bhatt'
    assert_not user.save, "Saved the user without its first_name"
  end

  test "should not save user without its field last_name" do
    user = User.new
    user.email='wonook@wonook.me'
    user.username='Alia'
    user.first_name='Aliaa'
    assert_not user.save, "Saved the user without its last_name"
  end

  test "password and its confirmation are same" do
    user = User.new
    user.organization_id=@organization.id
    user.email='wonook@wonook.me'
    user.username='Alia'
    user.first_name='Aliaa'
    user.last_name='Bhatt'
    user.password='Alia'
    user.password_confirmation='Alia'
    assert user.save, "Saved user has no authentication error"
  end

  test "password (is empty) and its confirmation are different" do
    user = User.new
    user.email='wonook@wonook.me'
    user.username='Alia'
    user.first_name='Aliaa'
    user.last_name='Bhatt'
    user.password=''
    user.password_confirmation='Alia'
    assert_not user.save, "Saved user has empty sting as password authentication error"
  end

  test "password and its confirmation are different" do
    user = User.new
    user.email='wonook@wonook.me'
    user.username='Alia'
    user.first_name='Aliaa'
    user.last_name='Bhatt'
    user.password='Not'
    user.password_confirmation='Alia'
    assert_not user.save, "Saved user has authentication error"
  end

  test "should not save user with existing username" do
    user1 = create(:user, username: "user")
    user2 = build(:user, username: "user")
    assert_not user2.save, "Saved user has an already existing username"
  end

  context "associations" do
    should belong_to(:organization)
  end

  context "validations" do
    # USERNAME
    should validate_uniqueness_of(:username)
    should validate_length_of(:username).is_at_most(10).on(:create)
    should allow_value("admin123").for(:username)
    should_not allow_value("admin_.123").for(:username)

    # CONTACT
    should allow_value(9884398843).for(:contact)
    should_not allow_value("John9884398843").for(:contact)

    # FIRST NAME
    should validate_length_of(:first_name).is_at_most(10).on(:create)
    should allow_value("John").for(:first_name)
    should_not allow_value("John_123").for(:first_name)

    # LAST NAME
    should validate_length_of(:last_name).is_at_most(10).on(:create)
    should allow_value("Smith").for(:last_name)
    should_not allow_value("Smith_123").for(:last_name)

    # ORGANIZATION ID
    should validate_presence_of(:organization_id)
  end

end
