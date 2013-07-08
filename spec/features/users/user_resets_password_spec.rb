require 'spec_helper'

feature 'resetting passwords', %q{
  As a user
  I want to reset my password
  so I can get a new one if I forget
} do

  # AC
  # I can create a new password for the same account
  # The old password is no longer valid

  include EmailSpec::Helpers
  include EmailSpec::Matchers

  scenario 'user resets password' do
    user = FactoryGirl.create(:user)
    reset_email
    visit welcome_page_path
    click_link 'Forgot your password?'
    fill_in 'user_email', with: user.email
    click_button 'Send reset instructions'
    expect(last_email).to have_body_text('Someone has requested
           a link to change your password')
    open_email(user.email)
    visit_in_email('Change my password')
    fill_in 'user_password', with: 'new_password'
    fill_in 'user_password_confirmation', with: 'new_password'
    click_button 'Change my password'
    click_link 'Sign out'
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: 'new_password'
    click_button 'Sign in'
    expect(page).to have_content('Recent activity')
  end

end
