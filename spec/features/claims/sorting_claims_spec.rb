require 'spec_helper'

describe "sorting claims" do

  extend ClaimsHarness
  create_factories_and_sign_in

  before { visit claims_path }

  context "persisting sort order after a search" do
    let!(:cl_amount) {  FactoryGirl.create(:claim, user_owed_to: user1,
                  user_who_owes: user2, amount: 2) }
    before do
      visit claims_path
      click_link 'Amount'
      fill_in 'z_amount_max', with: 500
      click_button 'Search Claims'
    end
    it "keeps the same sort order after a search" do
      expect( page.body.index(cl_amount.title) ).to be < page.body.index(cl.title)
    end
  end

  context "by owed_to" do

    before { click_link 'Owed to' }

    it "sorts by ascending order" do
      expect(page.body.index(cl.title)).to be < page.body.index(cl2.title)
    end
    it "sorts by descending if clicked again" do
      click_link 'Owed to'
      expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
    end
  end

  context "by owed_by" do
    before { click_link 'Owed by' }

    it "sorts by ascending order" do
      expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
    end
    it "sorts by ascending if clicked again" do
      click_link 'Owed by'
      expect(page.body.index(cl.title)).to be < page.body.index(cl2.title)
    end

  end

  context "by title" do
    before do
      cl2.update_attributes(title: 'aaaa')
      click_link 'Title'
    end

    it "sorts by ascending order" do
      expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
    end
    it "sorts by descending if clicked again" do
      click_link 'Title'
      expect(page.body.index(cl.title)).to be < page.body.index(cl2.title)
    end
  end

  context "by amount" do
    before do
      cl2.update_attributes(amount: 10)
      click_link 'Amount'
    end

    it "sorts by ascending order" do
      expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
    end
    it "sorts by descending if clicked again" do
      click_link 'Amount'
      expect(page.body.index(cl2.title)).to be > page.body.index(cl.title)
    end
  end

  context "by created on" do
    let!(:old_claim) { FactoryGirl.create(:claim, user_owed_to: user1,
                    user_who_owes: user2, created_at: 1.day.ago,
                    title: 'old title') }

    before { visit claims_path }

    it "sorts by descending order - newest first" do
      expect(page.body.index(cl.title)).to be < page.body.index(old_claim.title)
    end
    it "sorts by ascending if clicked again" do
      click_link 'Created on'
      expect(page.body.index(old_claim.title)).to be < page.body.index(cl.title)
    end
  end

  describe "default when attempting to enter non-valid sort and direction" do
    it "defaults to created_at descending" do
      visit '/claims?direction=crap&sort=morecrap'
      expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
    end
  end
end
