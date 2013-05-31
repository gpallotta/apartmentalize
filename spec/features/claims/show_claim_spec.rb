require 'spec_helper'

describe "show page for a claim" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:user3) { FactoryGirl.create(:user, group: group) }
  let!(:cl) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2)}

  before do
    sign_in user1
    visit claims_path
    visit claim_path(cl)
  end

  describe "viewing paid status" do

    it "displays unpaid if the claim is not paid" do
      expect(page).to have_content('Unpaid')
    end
    it "displays the date the claim was paid if it is paid" do
      click_link 'Mark as paid'
      visit claim_path(cl)
      expect(page).to have_content(cl.reload.paid_on.strftime("%B %d, %Y"))
    end
  end


  describe "marking as paid" do
    it "has a link to mark as paid if the claim is not paid" do
      expect(page).to have_link('Mark as paid',
                href: mark_as_paid_claim_path(cl))
    end
    it "does not have the link to mark as paid if the claim is paid" do
      click_link 'Mark as paid'
      visit claim_path(cl)
      expect(page).to have_content('Already paid')
      expect(page).not_to have_link('Mark as paid',
                href: mark_as_paid_claim_path(cl))
    end

  end

end
