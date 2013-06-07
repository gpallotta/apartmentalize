###############

# As a user, I want to
# see the effective balance between me and my roommates
# so we can easily zero out the balance between ourselves

# AC:
# I can see the difference between what I am owed and what I owe for each roommate

###############

require 'spec_helper'

describe "viewing effective balances" do

  extend ClaimsHarness
  create_factories_and_sign_in
  let!(:paid_cl) {  FactoryGirl.create(:claim, user_owed_to: user2,
                user_who_owes: user1, paid: true) }
  before { visit claims_path }

  context "total sum" do

    it "displays the total sum you owe (or are owed) for all displayed debts" do
      expect(page).to have_content(cl.amount + paid_cl.amount - cl2.amount)
    end

    it "displays the sum between you and each roommate" do
      cl3 = FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user3,
              amount: 7)
      cl4 = FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user3,
              amount: 9.34)
      visit claims_path
      expect(page).to have_content(cl3.amount + cl4.amount)
      expect(page).to have_content(cl.amount - cl2.amount + paid_cl.amount)
    end
  end

end
