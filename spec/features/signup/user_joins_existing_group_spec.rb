###############

# As a user
# I want to join an existing group
# so I can link up with my roommates on the site

# AC:
# I can enter an existing group identifier
# I am linked up correctly with the group
# I am notified if I enter an invalid identifier

###############


require 'spec_helper'

describe "signing up with joining an existing group" do

  before { visit new_group_path }

  context "when the identifier does not exist" do
    it "brings the user back to the new group page" do
      fill_in 'lookup_identifier', with: 'not here'
      click_button 'Lookup'
      expect(page).to have_content("Join existing group")
      expect(page).to have_content("Group not found")
    end
  end

  context "when the identifier exists" do
    before do
      FactoryGirl.create(:group, identifier: 'exists')
      fill_in 'lookup_identifier', with: 'exists'
      click_button 'Lookup'
    end

    it "displays the group identifier on the page" do
      should have_content('exists')
    end
  end

end
