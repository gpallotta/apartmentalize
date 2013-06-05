# ---------------
# As a user
# I want to see a feed of recent activity on the site
# so I know what has been going on

# AC:
# I see a feed of the most recent activity
# The feed includes creating and deleting debts, marking paid, and commenting
# I do not see my activity on the news feed
# Items which are older are not displayed
# I do not see items not related to me listed in the feed
# ---------------

require 'spec_helper'

describe "activity feed" do

  extend ClaimsHarness
  let!(:group) { FactoryGirl.create(:group) }
  let!(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:user3) { FactoryGirl.create(:user, group: group) }

  before { sign_in user1 }


  context "activity not related to me" do
    it "is not shown" do
    end
  end

  context "activity related to me" do
    it "shows when a new claim is posted" do
      visit claims_path
      fill_in
    end
    it "shows when a claim I owe is marked as paid" do
    end
    it "shows when a comment is psoted on anything I owe" do
    end
    it "does not show my own activity" do
    end
  end

end
