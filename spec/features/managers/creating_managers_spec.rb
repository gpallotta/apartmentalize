###############

# As a user
# I want to be able to store information about the landlord/property manager
# so we have a centralized place to find that information

# AC:
# I can attach a person of interest to the group

###############

require 'spec_helper'

describe "creating a new manager" do

  extend ManagersHarness
  create_factories_and_sign_in

  before do
    visit group_path(group)
    click_link 'Add An Important Person'
  end

  context "with invalid info" do
    it "does not create a manager" do
      expect { click_button 'Create' }.not_to change { Manager.count }
    end
  end

  context "with valid info" do

    before do
      fill_in 'Title', with: 'Awesome Dude'
      fill_in 'manager_name', with: 'Dude'
      fill_in 'Address', with: '123 Blueberry Lane'
      fill_in 'Phone Number', with: '1234567890'
    end

    it "creates a manager" do
      expect { click_button 'Create' }.to change { Manager.count }.by(1)
      expect(page).to have_content('Awesome Dude')
    end

  end

end
