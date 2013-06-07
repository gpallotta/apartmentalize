###############

# As a user
# I want to be able to sign into the site
# so that I can use it as myself

# AC:
# I can sign into the site
# I am prompted to enter my password for security

###############

require 'spec_helper'

describe "signing in" do

  context "with invalid information" do
    before do
      visit welcome_page_path
      click_button 'Sign in'
    end

    it "redirects to new session path" do
      expect(current_path).to eql(new_user_session_path)
    end

    describe "then clicking on the sign up link" do
      it "directs you to the new group page" do
        click_link 'Sign up'
        expect(current_path).to eql(new_group_path)
      end
    end
  end

  context "with valid information" do
    let!(:user) { FactoryGirl.create(:user) }
    before do
      visit welcome_page_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Sign in'
    end

    it "signs in the user" do
      expect(page).to have_link('Sign out')
      expect(current_path).to eql(home_page_path)
    end
  end
end
