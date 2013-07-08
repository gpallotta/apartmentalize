require 'spec_helper'

describe "user resetting password" do

  include EmailSpec::Helpers
  include EmailSpec::Matchers

  let!(:user) { FactoryGirl.create(:user) }

  before do
    reset_email
    visit welcome_page_path
    click_link 'Forgot your password?'
    fill_in 'user_email', with: user.email
    click_button 'Send reset instructions'
  end

  it "sends the user an email with a reset password link" do
    expect(last_email).to have_body_text('Someone has requested
           a link to change your password')
  end

  it "resets the user password if the link is clicked" do
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
