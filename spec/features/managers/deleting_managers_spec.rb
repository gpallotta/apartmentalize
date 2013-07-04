require 'spec_helper'

feature 'user deletes a manager', %q{
  As a user
  I want to be able to delete managers from the group
  in case they are no longer associated
} do

  # AC:
  # I can delete managers from the group
  # They no longer appear on the side

  extend ManagersHarness
  create_factories_and_sign_in

  scenario 'user deletes a manager' do
    visit user_path(user)
    click_link 'View info'
    click_link 'Edit'
    expect { click_link 'Delete' }.to change { Manager.count} .by(-1)
    expect(page).not_to have_content(manager.name)
  end

end
