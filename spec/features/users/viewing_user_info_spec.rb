require 'spec_helper'

feature 'user viewing information', %q{
  As a user
  I want to view my information on the site
  so I can see if it is up to date
} do

  # AC:
  # I can view my information when I am logged in

  given(:user) { FactoryGirl.create(:user) }

  before do
    sign_in user
    visit user_path(user)
  end

  scenario 'user visits profile page' do
    expect(page).to have_content(user.name)
    expect(page).to have_content(user.email)
    expect(page).to have_content(user.group.identifier)
    expect(page).to have_link('Edit', href: edit_user_registration_path(user))
    expect(page).to have_link('Group Info', href: group_path(user.group) )
  end

  scenario 'user visits profile page of another user' do
    user2 = FactoryGirl.create(:user)
    sign_out user
    sign_in user2
    visit user_path(user)
    expect(current_path).to eql home_page_path
  end

end
