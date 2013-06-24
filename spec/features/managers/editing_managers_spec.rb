###############

# As a user
# I want to edit manager information
# so I can update it if it changes

# AC:
# I can edit the information for a manager
# The new information is reflected in the app

###############


require 'spec_helper'

describe "editing a manager" do

  extend ManagersHarness
  create_factories_and_sign_in

  before do
    visit user_path(user)
    within('.important-people') do
      click_link 'Edit'
    end
  end

  context "with invalid info" do
    before do
      fill_in 'manager_name', with: ''
      click_button 'Save Changes'
    end

    it "does not save the changes" do
      expect(manager.reload.name).not_to eql('')
    end
  end

  context "with valid info" do
    before do
      fill_in 'manager_name', with: 'New Name'
      click_button 'Save Changes'
    end
    it "saves the changes" do
      expect(page).to have_content('New Name')
    end
  end

end
