#########################
#
# As a user
# I want to mark debts as paid
# so I can indicate when something has been paid off

# AC:
# I can mark a debt as paid
# I no longer see the debt in the list of unpaid debts
# The debt's amount is no longer reflected in the totals people owe me
# I no longer see the link to mark the debt as paid

#########################


require 'spec_helper'

describe "marking claims as paid" do

  extend ClaimsHarness
  create_factories_and_sign_in

  describe "on the claims index page" do

    before do
      visit claims_path
      click_link 'Mark paid'
    end

    it "marks the debt as paid" do
      expect(cl.reload.paid).to be_true
      expect(current_path).to eql(claims_path)
    end
  end

  describe "on the claims show page" do
    before do
      visit claim_path(cl)
    end

    it "has a link to mark as paid if the claim is not paid" do
      expect(page).to have_link('Mark as paid',
                href: mark_as_paid_claim_path(cl))
    end

    it "displays unpaid if the claim is not paid" do
      expect(page).to have_content('Unpaid')
    end

    it "marks the debt as paid" do
      click_link 'Mark as paid'
      expect(cl.reload.paid).to be_true
      expect(current_path).to eql(claim_path(cl))
    end

    it "does not have the link to mark as paid if the claim is paid" do
      click_link 'Mark as paid'
      expect(page).to have_content('Already paid')
      expect(page).not_to have_link('Mark as paid',
                href: mark_as_paid_claim_path(cl))
    end

    it "displays the date the claim was paid if it is paid" do
      click_link 'Mark as paid'
      visit claim_path(cl)
      expect(page).to have_content(cl.reload.paid_on.strftime("%B %d, %Y"))
    end
  end

end


