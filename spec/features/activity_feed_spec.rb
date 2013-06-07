###############

# As a user
# I want to see a feed of recent activity on the site
# so I know what has been going on

# AC:
# I see a feed of the most recent activity
# The feed includes creating and deleting debts, marking paid, and commenting
# I do not see my activity on the news feed
# Items which are older are not displayed
# I do not see items not related to me listed in the feed

###############


require 'spec_helper'

describe "activity feed" do

  extend ClaimsHarness
  let!(:group) { FactoryGirl.create(:group) }
  let!(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:user3) { FactoryGirl.create(:user, group: group) }
  let!(:cl1) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2) }
  let!(:cl2) { FactoryGirl.create(:claim, user_owed_to: user2, user_who_owes: user3) }

  describe "activity not related to me" do
    before do
      sign_in user2
      visit claim_path(cl2)
      fill_in 'comment_content', with: 'Not related'
      click_button 'Comment'
      sign_out user2
    end

    it "is not shown" do
      sign_in user1
      expect(page).not_to have_content("#{user2.name} commented on #{cl2.title}")
    end
  end

  describe "activity related to me" do
    before do
      sign_in user2
      visit claims_path
      fill_in 'claim_title', with: 'Cable'
      fill_in 'claim_amount', with: 20
      click_button 'Create Claim'
      c = Claim.find_by_title('Cable')
      visit claim_path(c)
      fill_in 'comment_content', with: 'Turtles'
      click_button 'Comment'
      sign_out user2
      sign_in user1
    end

    let!(:c) { Claim.find_by_title("Cable") }

    context "claims" do
      context "create" do
        it "shows when a new claim is posted" do
          expect(page).to have_content("#{user2.name} created a new claim for")
        end
        it "links to the claim" do
          expect(page).to have_link( "#{c.title}", href: claim_path(c) )
        end
      end

      context "mark_as_paid" do
        it "shows when a claim I owe is marked as paid" do
          sign_out user1
          sign_in user2
          visit claim_path(c)
          click_link 'Mark as paid'
          sign_out user2
          sign_in user1
          expect(page).to have_content("#{user2.name} marked #{c.title} as paid")
          expect(page).to have_link( "#{c.title}", href: claim_path(c) )
        end
      end

      context "update" do
        before do
          sign_out user1
          sign_in user2
          visit edit_claim_path(c)
          fill_in 'claim_amount', with: 11
          click_button 'Save changes'
          sign_out user2
          sign_in user1
        end

        it "shows when a claim I owe is edited" do
          expect(page).to have_content("#{user2.name} edited #{c.title}")
          expect(page).to have_link(c.title, href: claim_path(c))
        end
      end

      context "comments" do
        it "shows when a comment is posted on anything I owe/am owed" do
          expect(page).to have_content("#{user2.name} commented on")
        end
      end

      it "shows the 10 most recent items" do
        sign_out user1
        sign_in user2
        visit claims_path
        11.times do |i|
          fill_in 'claim_title', with: "Title #{i}"
          fill_in 'claim_amount', with: 5
          click_button 'Create Claim'
        end
        sign_out user2
        sign_in user1
        expect(page).not_to have_content('Title 0')
      end

    end


    context "my own activity" do
      it "is not shown" do
        visit claims_path
        fill_in 'claim_title', with: 'Mine'
        fill_in 'claim_amount', with: 3
        click_button 'Create Claim'
        visit home_page_path
        expect(page).not_to have_content("#{user1.name} created a new claim for #{Claim.last.title}")
      end
    end
  end

end
