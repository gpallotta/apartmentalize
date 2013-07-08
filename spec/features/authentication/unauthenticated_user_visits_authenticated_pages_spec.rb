require 'spec_helper'

feature 'an unauthenticated user visiting pages which need authentication', %q{
  As an authenticated user
  I want to be redirected to the sign in page when I visit pages which require me to be authenticated
  so that I don't see things I'm not supposed to or cause errors
} do

  # AC
  # I cannot visit the claim, home, comment, or user/group info pages if I am not authenticated
  # I am redirected back to the welcome page

  scenario 'unauthenticated user visits claims index page' do
    visit claims_path
    expect(current_path).to eql(new_user_session_path)
  end

  scenario 'unauthenticated user visits group page' do
    group = FactoryGirl.create(:group)
    visit group_path(group)
    expect(current_path).to eql(new_user_session_path)
  end

  scenario 'unauthenticated user visits user profile page' do
    user = FactoryGirl.create(:user)
    visit user_path(user)
    expect(current_path).to eql(new_user_session_path)
  end

  scenario 'unauthenticated user visits edit user page' do
    user = FactoryGirl.create(:user)
    visit edit_user_registration_path(user)
    expect(page).to have_content('You need to sign in or sign up')
  end

  scenario 'unauthenticated user visits help page' do
    visit help_page_path
    expect(current_path).to eql(new_user_session_path)
  end

  scenario 'unauthenticated user visits chore pages' do
    visit chores_path
    expect(current_path).to eql(new_user_session_path)
    chore = FactoryGirl.create(:chore)
    visit edit_chore_path(chore)
    expect(current_path).to eql(new_user_session_path)
  end

  scenario 'user signs in and is redirect to original target page' do
    user = FactoryGirl.create(:user)
    visit claims_path
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Sign in'
    expect(current_path).to eql(claims_path)
  end

end
