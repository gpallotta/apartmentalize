require 'spec_helper'

describe "claim pages" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:user3) { FactoryGirl.create(:user, group: group) }

  before do
    sign_in user1
    visit claims_path
  end

  subject { page }

  describe "creating claims" do
    context "with invalid info" do
      it "does not create a claim" do
        expect { click_button 'Create Claim' }.not_to change {Claim.count}
      end

    end

    context "with valid info" do

      before do
        fill_in 'claim_title', with: 'Test'
        fill_in 'claim_amount', with: 5
      end

      context "for all other users" do

        it "creates a claim for all users" do
          expect { click_button 'Create Claim' }.to change { Claim.count }.by(2)
        end
        it "displays the new claims" do
          click_button 'Create Claim'
          should have_content('Test')
          should have_content(5)
        end

      end

      context "for only some users" do
        before { uncheck "#{user2.name}" }
        it "creates the debt for only the checked users" do
          expect { click_button 'Create Claim' }.to change {Claim.count }.by(1)
        end
      end
    end
  end

  describe "editing claims" do
    let!(:cl) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2)}
    before do
      visit claims_path
      click_link 'Edit'
    end

    context "with invalid info" do
      before do
        fill_in 'claim_amount', with: 'String'
        click_button 'Save changes'
      end

      it "does not save the updated info" do
        expect(cl.reload.amount).not_to eql('String')
      end
      it "re-renders the edit page" do
        expect(current_path).to eql( "/claims/#{cl.id}" )
      end
    end

    context "with valid info" do
      before do
        fill_in 'claim_title', with: 'Updated title'
        click_button 'Save changes'
      end

      it "saves the changes" do
        expect(cl.reload.title).to eql("Updated title")
      end
      it "displays the new information" do
        expect(page).to have_content('Updated title')
      end
      it "redirects to the claims path" do
        expect(current_path).to eql(claims_path)
      end
    end

    describe "deleting claims" do
      before { click_link 'Delete' }

      it "deletes the claim" do
        expect(Claim.find_by_id(cl.id)).to be_nil
      end
      it "redirects to the claims index page" do
        expect(current_path).to eql(claims_path)
      end
      it "no longer displays info about the claim" do
        expect(page).not_to have_content(cl.title)
      end
    end
  end

  describe "viewing claims" do
    it "displays all unpaid claims related to you by default" do
    end
  end

end
