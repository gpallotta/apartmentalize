require 'spec_helper'

describe "front pages" do

  let!(:group) { FactoryGirl.create(:group) }
  let!(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:user3) { FactoryGirl.create(:user, group: group) }

  context "authenticated" do

    before do
      sign_in user1
      visit claims_path
      fill_in 'claim_title', with: 'Random stuff'
      fill_in 'claim_amount', with: 5
      click_button 'Create Claim'
      visit claim_path(Claim.first)
      fill_in 'comment_content', with: 'Some comment'
      click_button 'Comment'
      visit claims_path
      find(:xpath, "//a[@href='/claims/#{Claim.first.id}/mark_as_paid']").click
    end

    describe "current chore" do
      let!(:chore) { FactoryGirl.create(:chore, user: user1)}
      it "shows chores currently assigned to you" do
        visit home_page_path
        expect(page).to have_content(chore.title)
      end
    end

    describe "debt links" do
      pending
    end

  end

  context "unauthenticated" do
  end



end
