require 'spec_helper'

describe "sorting claims" do

  extend ClaimsHarness
  create_factories_and_sign_in

  before { visit claims_path }

  context "by owed_to" do

    before { click_link 'Owed to' }

    it "sorts by descending order" do
      expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
    end
    it "sorts by acesnding if clicked again" do
      click_link 'Owed to'
      expect(page.body.index(cl2.title)).to be > page.body.index(cl.title)
    end
  end

  context "by owed_by" do
    before { click_link 'Owed by' }

    it "sorts by descending order" do
      expect(page.body.index(cl.title)).to be < page.body.index(cl2.title)
    end
    it "sorts by ascending if clicked again" do
      click_link 'Owed by'
      expect(page.body.index(cl.title)).to be > page.body.index(cl2.title)
    end

  end

  context "by title" do
    before do
      cl2.update_attributes(title: 'aaaa')
      click_link 'Title'
    end

    it "sorts by descending order" do
      expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
    end
    it "sorts by ascending if clicked again" do
      click_link 'Title'
      expect(page.body.index(cl.title)).to be < page.body.index(cl2.title)
    end
  end

  context "by amount" do
    before do
      cl2.update_attributes(amount: 10)
      click_link 'Amount'
    end

    it "sorts by descending order" do
      expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
    end
    it "sorts by ascending if clicked again" do
      click_link 'Amount'
      expect(page.body.index(cl2.title)).to be > page.body.index(cl.title)
    end
  end

  context "by created on" do
    let!(:old_claim) { FactoryGirl.create(:claim, user_owed_to: user1,
                    user_who_owes: user2, created_at: 1.day.ago,
                    title: 'old title') }
    before do
      click_link 'Created on'
    end

    it "sorts by descending order" do
      expect(page.body.index(old_claim.title)).to be < page.body.index(cl.title)
    end
    it "sorts by ascending if clicked again" do
      click_link 'Created on'
      expect(page.body.index(old_claim.title)).to be > page.body.index(cl.title)
    end
  end
end
