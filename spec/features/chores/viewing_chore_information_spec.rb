require 'spec_helper'

feature 'user views chore information', %q{
  As a user
  I want to see information about each chore
  so I know what I need to do
} do

  # AC:
  # I can see the name and description of chores
  # I can see who all chores are assigned to

  extend ChoresHarness
  create_factories_and_sign_in

  scenario 'user visits chores index page' do
    visit chores_path
    expect(page).to have_content(ch1.title)
    expect(page).to have_content(ch1.description)
    expect(page).to have_content(ch1.user.name)
  end

end
