###############

# As a user
# I want to edit debts
# so I can correct erroneous information

# AC:
# I can edit a debt
# The new amount and title are reflected on the view pages

###############


require 'spec_helper'

describe "editing claims" do

  extend ClaimsHarness
  create_factories_and_sign_in

  before do
    visit claim_path(cl)
    click_link 'Edit'
  end

  context "with invalid info" do
    before do
      fill_in 'claim_amount', with: 'String'
      click_button 'Save changes'
    end

    it "does not save the updated info" do
      expect(cl.reload.amount).not_to eql('String')
    end
    it "re-renders the edit page" do
      expect(current_path).to eql( "/claims/#{cl.id}" )
    end
  end

  context "with valid info" do
    before do
      fill_in 'claim_title', with: 'Updated title'
      click_button 'Save changes'
    end

    it "saves the changes" do
      expect(cl.reload.title).to eql("Updated title")
    end
    it "displays the new information" do
      expect(page).to have_content('Updated title')
    end
    it "redirects to the claim view page" do
      expect(current_path).to eql(claim_path(cl))
    end
  end

end
