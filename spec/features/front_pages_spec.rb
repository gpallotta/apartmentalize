###############

# As a user
# I want to see a list of important info on the front page
# so that I can quickly get information

# AC:
# I see my current chore on the front page
# I see balances between my roommates and I

###############


require 'spec_helper'

describe "front pages" do

  extend ClaimsHarness
  create_factories_and_sign_in

  let!(:chore) { FactoryGirl.create(:chore, user: user1)}
  let!(:cl3) { FactoryGirl.create(:claim, user_owed_to: user1,
                user_who_owes: user3, amount: 5.5) }

  before { visit home_page_path }

  describe "current chore" do
    it "shows chores currently assigned to you" do
      expect(page).to have_content(chore.title)
    end
  end

  describe "claim balances" do
    it "shows all effective balances between my and each roommate" do
      expect(page).to have_content("Balance for #{user2.name}")
      expect(page).to have_content("Balance for #{user3.name}")
      expect(page).to have_content(cl.amount - cl2.amount)
      expect(page).to have_content(cl3.amount)
    end
  end


end
