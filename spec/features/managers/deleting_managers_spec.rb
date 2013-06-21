###############

# As a user
# I want to be able to delete managers from the group
# in case they are no longer associated

# AC:
# I can delete managers from the group
# They no longer appear on the side

###############


require 'spec_helper'

describe "manager pages" do

  extend ManagersHarness
  create_factories_and_sign_in

  before do
    visit user_path(user)
    within('.important-people') do
      click_link 'Edit'
    end
  end

  describe "deleting a manager" do
    it "deletes the manager" do
      expect { click_link 'Delete' }.to change { Manager.count} .by(-1)
      expect(page).not_to have_content(manager.name)
    end
  end

end
