require 'spec_helper'

describe "viewing manager info" do

  extend ManagersHarness
  create_factories_and_sign_in

  before { visit group_path(group) }

  it "displays info about each manager" do
    expect(page).to have_content(manager.name)
    expect(page).to have_content(manager.title)
    expect(page).to have_content(manager.email)
    expect(page).to have_content(manager.address)
    expect(page).to have_content(manager.phone_number)
  end

  it "has a link to create a new manager" do
    expect(page).to have_link("Add An Important Person", href: new_manager_path)
  end

  it "has a link to edit a manager" do
    expect(page).to have_link("Edit", href: edit_manager_path(manager) )
  end
end
