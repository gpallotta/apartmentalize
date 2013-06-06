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
    end

    it "redirects back to the home page" do
      expect(current_path).to eql(home_page_path)
    end
  end

  context "new_user_password_path" do
    before { visit new_user_password_path }

    it "does not display the password page content" do
      expect(page).not_to have_content('Forgot your password?')
    end

    it "redirects back to the home page" do
      expect(current_path).to eql(home_page_path)
    end
  end

  context "new_user_session_path" do
    before { visit new_user_session_path }

    it "does not display the sign in page content" do
      expect(page).not_to have_content('Sign in')
    end

    it "redirects back to the home page" do
      expect(current_path).to eql(home_page_path)
    end

  end

  context "new_user_registration_path" do
    before { visit new_user_registration_path }
    it "does not display the user signup form" do
      expect(page).not_to have_content('Sign up')
    end

    it "redirects back to the home page" do
      expect(current_path).to eql(home_page_path)
    end

  end

end
