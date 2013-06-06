####################

# As a user
# I want to be redirected back to the front page if I visit signup pages when logged in
# so that I can't do weird stuff to Greg's app

# Acceptance Criteria
# I cannot visit the group or user signup pages when authenticated
# I am redirected back to the home page when I attempt to visit the above pages

####################

require 'spec_helper'

describe "an authenticated user visiting the signup pages" do
  let!(:user) { FactoryGirl.create(:user) }

  before { sign_in user }

  context "new_group_path" do
    before { visit new_group_path }

    it "does not show the new group page" do
      expect(page).not_to have_content('Join existing group')
      expect_redirect_to_home_path
    end
  end

  context "new_user_password_path" do
    before { visit new_user_password_path }

    it "does not display the password page content" do
      expect(page).not_to have_content('Forgot your password?')
      expect_redirect_to_home_path
    end
  end

  context "new_user_session_path" do
    before { visit new_user_session_path }

    it "does not display the sign in page content" do
      expect(page).not_to have_content('Sign in')
      expect_redirect_to_home_path
    end
  end

  context "new_user_registration_path" do
    before { visit new_user_registration_path }
    it "does not display the user signup form" do
      expect(page).not_to have_content('Sign up')
      expect_redirect_to_home_path
    end
  end

  context "welcome_page_path" do
    before { visit welcome_page_path }
      it "does not take the user to the welcome page" do
        expect(page).not_to have_content('An app you can use to')
        expect_redirect_to_home_path
      end
   end

  def expect_redirect_to_home_path
    expect(current_path).to eql(home_page_path)
  end

end
