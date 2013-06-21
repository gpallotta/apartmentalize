###############

# As a user
# I want to view information about the managers I add to the user
# so that I can see the info I need to contact them

# AC:
# I can see the information entered for a manager on the groups page

###############

require 'spec_helper'

describe "viewing manager info" do

  extend ManagersHarness
  create_factories_and_sign_in

  before { visit user_path(user) }

  it "displays info about each manager" do
    expect(page).to have_content(manager.name)
    expect(page).to have_content(manager.title)
    expect(page).to have_content(manager.email)
    expect(page).to have_content(manager.address)
    expect(page).to have_content(manager.phone_number)
  end

  it "has a link to create a new manager" do
    expect(page).to have_link("Add", href: new_manager_path)
  end

  it "has a link to edit a manager" do
    expect(page).to have_link("Edit", href: edit_manager_path(manager) )
  end
end
