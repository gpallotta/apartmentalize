require 'spec_helper'

describe "index page" do

  extend ClaimsHarness
  create_factories_and_sign_in
  let!(:cl2) { FactoryGirl.create(:claim, user_owed_to: user2, user_who_owes: user1)}
  let!(:roommate_cl) { FactoryGirl.create(:claim,
                user_owed_to: user3, user_who_owes: user2)}
  let!(:paid_cl) {  FactoryGirl.create(:claim, user_owed_to: user2,
                user_who_owes: user1, paid: true) }

  before { visit claims_path }

  context "viewing claims within your group" do
    it "displays all claims related to you by default" do
      expect(page).to have_content(cl.title)
      expect(page).to have_content(cl2.title)
    end
    it "does not display claims that are between others in your group" do
      expect(page).not_to have_content(roommate_cl.title)
    end
    it "displays the title of a claim" do
      expect(page).to have_content(cl.title)
    end
    it "displays the amount of a claim" do
      expect(page).to have_content(cl.amount)
    end
    it "has a link to view a single debt" do
      expect(page).to have_link('View', href: claim_path(cl))
    end
    it "has a link to mark debts you are owed as paid" do
      expect(page).to have_link('Mark paid', href: mark_as_paid_claim_path(cl))
    end
    it "does not have a link to mark paid debts as paid" do
      expect(page).not_to have_link('Mark paid', href: mark_as_paid_claim_path(paid_cl))
    end
    it "does not have a link to mark debts you owe as paid" do
      expect(page).not_to have_link('Mark paid', href: mark_as_paid_claim_path(cl2))
    end
  end

  context "viewing claims from other groups" do
    let(:other_group) { FactoryGirl.create(:group) }
    let(:other_user) { FactoryGirl.create(:user, group: group) }
    let!(:other_claim) { FactoryGirl.create(:claim, user_owed_to: other_user,
                          user_owed_to: other_user)}
    it "does not show claims from other groups" do
      visit claims_path
      expect(page).not_to have_content(other_claim.title)
    end
  end
end
