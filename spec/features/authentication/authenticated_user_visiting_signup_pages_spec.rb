require 'spec_helper'

feature 'authenticated user visiting the front pages', %q{
  As a user
  I want to be redirected back to the front page if I visit signup pages when logged in
  so that I can't do weird stuff to Greg's app
} do

  # Acceptance Criteria
  # I cannot visit the group or user signup pages when authenticated
  # I am redirected back to the home page when I attempt to visit the above pages

  given(:user) { FactoryGirl.create(:user)}
  before(:each) { sign_in user }

  scenario 'authenticated user visits the new group page' do
    visit new_group_path
    expect(page).not_to have_content('Join existing group')
    expect_redirect_to_home_path
  end

  scenario 'authenticated user visits new password path' do
    visit new_user_password_path
    expect(page).not_to have_content('Forgot your password?')
    expect_redirect_to_home_path
  end

  scenario 'authenticated user visits sign in page' do
    visit new_user_session_path
    expect(page).not_to have_content('Sign in')
    expect_redirect_to_home_path
  end

  scenario 'authenticated user visits new user page' do
    visit new_user_registration_path
    expect(page).not_to have_content('Sign up')
    expect_redirect_to_home_path
  end

  scenario 'authenticated user visits welcome page path' do
    visit welcome_page_path
    expect(page).not_to have_content('An app you can use to')
    expect_redirect_to_home_path
  end

  def expect_redirect_to_home_path
    expect(current_path).to eql(user_root_path)
  end

end
