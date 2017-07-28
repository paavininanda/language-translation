require 'test_helper'

class UserActionTest < ActionDispatch::IntegrationTest

	let(:organization) { FactoryGirl.create(:organization, name: "Red Cross") }
	let(:language) { FactoryGirl.create(:language, name: "Swahili") }

	describe "create new user" do
		describe "create new user success" do
			before do
				organization
				language
				visit '/signup'
			end

			it "fills up form and submits" do
				select 'Red Cross', from: 'user_organization_id'
				fill_in 'user_email', with: 'test_mail@gmail.com'
				fill_in 'user_username', with: 'test_user'
				fill_in 'user_first_name', with: 'test_fname'
				fill_in 'user_last_name', with: 'test_lname'
				choose 'user_gender_female'
				select 'Swahil', from: 'user_lang'
				fill_in 'user_password', with: 'test_pwd'
				fill_in 'user_password_confirmation', with: 'test_pwd'
				click_button 'SignUp'
			end

			it "signs up user" do
				page.has_content?('Welcome! You have signed up successfully.')
			end
		end

		describe "create new user failure" do
			before do
				organization
				language
				visit '/signup'
			end

			it "fills up form and submits" do
				fill_in 'user_email', with: 'test_mail@gmail.com'
				fill_in 'user_username', with: 'test_user'
				fill_in 'user_first_name', with: 'test_fname'
				fill_in 'user_last_name', with: 'test_lname'
				choose 'user_gender_female'
				select 'Swahil', from: 'user_lang'
				fill_in 'user_password', with: 'test_pwd'
				fill_in 'user_password_confirmation', with: 'test_pwd'
				click_button 'SignUp'
			end

			it "does not sign up user" do
				page.has_content?('Prohibited this user from being saved:')
			end
		end
	end

	describe "get login page" do
		describe "logs in successfully" do
	  	before do
	  		visit '/login'
	  		fill_in 'username', :with => 'superadmin'
	  		fill_in 'password', :with => 'superadmin'
	  		click_button 'LogIn'
	  	end

	  	it "logs user in" do
	  		page.has_content?('Signed in successfully.')
	  	end
		end

		describe "log in failed" do
	  	before do
	  		visit '/login'
	  		fill_in 'username', :with => 'superadmin'
	  		fill_in 'password', :with => 'super'
	  		click_button 'LogIn'
	  	end

	  	it "logs user in" do
	  		page.has_content?('Invalid username or password.')
	  	end
	  end
  end

  describe "change user details" do
  	describe "update details successfully" do
  		before do
				user = create(:user, username: "superadmin", password: "superadmin")
				visit '/profile'
				fill_in 'username', :with => 'superadmin'
				fill_in 'password', :with => 'superadmin'
	  		click_button 'LogIn'
			end

			it "updates profile details" do
				fill_in 'user_email', with: 'test_mail@gmail.com'
				fill_in 'user_password', with: 'test_pwd'
				fill_in 'user_password_confirmation', with: 'test_pwd'
				fill_in 'user_current_password', with: 'superadmin'
				click_button 'Submit'
			end

			it "successfully updates the details" do
				page.has_content?('You updated your account successfully.')
			end
		end

  	describe "update details failure" do
			before do
				user = create(:user, username: "superadmin", password: "superadmin")
				visit '/profile'
				fill_in 'username', :with => 'superadmin'
				fill_in 'password', :with => 'superadmin'
				click_button 'LogIn'
			end

			it "updates profile details" do
				fill_in 'user_email', with: 'test_mail@gmail.com'
				fill_in 'user_password', with: 'test_pwd'
				fill_in 'user_password_confirmation', with: 'test'
				fill_in 'user_current_password', with: 'superadmin'
				click_button 'Submit'
			end

			it "fails to update the details" do
				page.has_content?("Password confirmation doesn't match Password")
			end
		end
  end
end