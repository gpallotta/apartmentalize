require 'spec_helper'

feature 'signing out', %q{
  As a user
  I want to be able to sign out of the site
  so I can protect access to my account on public computers
} do

  # AC:
  # I can sign out
  # After I do, I can no longer access pages which require authentication

  scenario 'user signs out' do
    user = FactoryGirl.create(:user)
    sign_in user
    expect(page).to have_link('Sign out', href: destroy_user_session_path)
    click_link 'Sign out'
    expect(current_path).to eql(welcome_page_path)
    expect(page).to have_button('Sign in')
  end

end
