require 'spec_helper'

feature 'user views manager info', %q{
  As a user
  I want to view information about the managers I add to the user
  so that I can see the info I need to contact them
} do

  # AC:
  # I can see the information entered for a manager on the groups page

  extend ManagersHarness
  create_factories_and_sign_in

  scenario 'user views manager info on user show page' do
    visit user_path(user)
    expect(page).to have_content(manager.name)
    expect(page).to have_content(manager.title)
    expect(page).to have_link("Add", href: new_manager_path)
    expect(page).to have_link('View info', href: manager_path(manager))
  end

  scenario 'user views manager info on manager show page' do
    visit user_path(user)
    click_link 'View info'
    expect(page).to have_content(manager.name)
    expect(page).to have_content(manager.title)
    expect(page).to have_content(manager.email)
    expect(page).to have_content(manager.address)
    expect(page).to have_content(manager.phone_number)
    expect(page).to have_link("Edit", href: edit_manager_path(manager) )
  end

end
