require 'spec_helper'

describe "signing up with creating a new group" do

  describe "sign up link" do
    it "takes the user to the new group page" do
      visit welcome_page_path
      click_link 'Sign up'
      expect(current_path).to eql(new_group_path)
    end
  end

  describe "looking up group" do

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

end
