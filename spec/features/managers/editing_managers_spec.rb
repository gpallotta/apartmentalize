require 'spec_helper'

feature 'user edits manager', %q{
  As a user
  I want to edit manager information
  so I can update it if it changes
} do

  extend ManagersHarness
  create_factories_and_sign_in

  # AC:
  # I can edit the information for a manager
  # The new information is reflected in the app

  before(:each) do
    visit user_path(user)
    click_link 'View info'
    click_link 'Edit'
  end

  scenario 'user edits manager with valid info' do
    fill_in 'manager_name', with: 'New Name'
    click_button 'Save Changes'
    expect(page).to have_content('New Name')
  end

  scenario 'user edits manager with invalid info' do
    fill_in 'manager_name', with: ''
    click_button 'Save Changes'
    expect(manager.reload.name).not_to eql('')
  end

end
