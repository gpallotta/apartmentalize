###############

# As a user
# I want to be able to sign out of the site
# so I can protect access to my account on public computers

# AC:
# I can sign out
# After I do, I can no longer access pages which require authentication

###############

require 'spec_helper'

describe "signing out" do
  let!(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  it "has a sign out link" do
    expect(page).to have_link('Sign out', href: destroy_user_session_path)
  end

  describe "by clicking the sign out link" do
    it "signs out the user" do
      click_link 'Sign out'
      expect(current_path).to eql(welcome_page_path)
      expect(page).to have_button('Sign in')
    end
  end

  describe "after signing out" do
    it "removes access to authenticated pages by redirect" do
      click_link 'Sign out'
      visit claims_path
      expect(current_path).to eql(new_user_session_path)
    end
  end

end
