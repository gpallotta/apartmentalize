require 'spec_helper'

feature 'signing in', %q{
  As a user
  I want to be able to sign into the site
  so that I can use it as myself
} do

  # AC:
  # I can sign into the site
  # I am prompted to enter my password

  before(:each) { visit welcome_page_path }

  scenario 'user signs in with valid info' do
    user = FactoryGirl.create(:user)
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Sign in'
    expect(page).to have_link('Sign out')
    expect(current_path).to eql(user_root_path)
  end

  scenario 'user signs in with invalid info' do
    click_button 'Sign in'
    expect(current_path).to eql(new_user_session_path)
    click_link 'Sign up'
    expect(current_path).to eql(new_group_path)
  end

end
