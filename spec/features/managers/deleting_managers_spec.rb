require 'spec_helper'

describe "manager pages" do

  extend ManagersHarness
  create_factories_and_sign_in

  before do
    visit group_path(group)
    click_link 'Edit'
  end

  describe "deleting a manager" do
    it "deletes the manager" do
      click_link 'Delete'
      expect(page).not_to have_content(manager.name)
    end
  end

end
