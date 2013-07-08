require 'spec_helper'

feature 'editing user information', %q{
  As a user
  I want to be able to edit my information
  so I can update it as necessary
} do

  # AC:
  # I can edit my information
  # The new information is reflected in my account

  given(:user) { FactoryGirl.create(:user) }

  scenario 'user edits with invalid info' do
    sign_in user
    before_email = user.email
    visit edit_user_registration_path(user)
    fill_in 'Email', with: ''
    fill_in 'user_current_password', with: user.password
    click_button 'Update'
    expect(user.reload.email).to eql(before_email)
    expect(page).to have_content("can't be blank")
  end

  scenario 'user edits with invalid info' do
    sign_in user
    visit edit_user_registration_path(user)
    fill_in 'Email', with: 'new@new_email.com'
    fill_in 'user_current_password', with: user.password
    click_button 'Update'
    expect(user.reload.email).to eql('new@new_email.com')
    expect(page).to have_content('new@new_email.com')
    expect(current_path).to eql(user_path(user))
  end

  scenario 'user goes to edit page when not signed in' do
    visit edit_user_registration_path
    expect(current_path).to eql(new_user_session_path)
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_button 'Sign in'
    expect(current_path).to eql(edit_user_registration_path)
  end

end
