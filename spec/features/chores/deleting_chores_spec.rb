require 'spec_helper'

feature 'user deletes chore', %q{
  As a user
  I want to delete chores
  so that I can remove ones we no longer need
} do

  # AC:
  # I can delete chores
  # The chores no longer are displayed
  # The chore is removed from the app

  extend ChoresHarness
  create_factories_and_sign_in

  scenario 'user deletes chore' do
    visit chores_path
    click_link 'Edit'
    expect{ click_link 'Delete' }.to change{ Chore.count }.by(-1)
    expect(page).not_to have_content(ch1)
  end

end
