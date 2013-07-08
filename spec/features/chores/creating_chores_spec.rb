require 'spec_helper'

feature 'user creates a chore', %q{
  As a user
  I want to create chores
  so I can keep track of who is supposed to do what
} do

  # AC:
  # I can create chores
  # I can assign the chores to someone
  # I can give the chore a description
  # I can assign multiple chores to someone

  extend ChoresHarness
  create_factories_and_sign_in

  before(:each) { visit chores_path }

  scenario 'user creates chore with valid info' do
    expect { click_button 'Create Chore' }.not_to change { group.chores.count }
  end

  scenario 'user creates chore with invalid info' do
    fill_in 'chore_title', with: 'Test title'
    fill_in 'chore_description', with: 'Test description'
    select(user.name, :from => 'chore_user_id')
    expect { click_button 'Create Chore' }.to change { Chore.count }.by(1)
    expect(page).to have_content('Test title')
  end

end
