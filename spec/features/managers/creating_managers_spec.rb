require 'spec_helper'

feature 'user creates an important person', %q{
  As a user
  I want to be able to store information about the landlord/property manager
  so we have a centralized place to find that information
} do

  # AC:
  # I can attach a person of interest to the user

  extend ManagersHarness
  create_factories_and_sign_in

  before(:each) do
    visit user_path(user)
    click_link 'Add'
  end

  scenario 'user creates an important person with invalid info' do
    expect { click_button 'Create' }.not_to change { Manager.count }
  end

  scenario 'user creates an important person with valid info' do
    fill_in 'Title', with: 'Awesome Dude'
    fill_in 'manager_name', with: 'Dude'
    fill_in 'Address', with: '123 Blueberry Lane'
    fill_in 'manager_phone_number', with: '1234567890'
    expect { click_button 'Create' }.to change { Manager.count }.by(1)
    expect(page).to have_content('Awesome Dude')
  end

end
