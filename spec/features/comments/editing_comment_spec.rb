require 'spec_helper'

describe "editing comments" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:cl) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2)}
  let!(:com) { FactoryGirl.create(:comment, claim: cl, user: user1)}

  before do
    sign_in user1
    visit claim_path(cl)
    click_link 'Edit Comment'
  end

  context "with invalid info" do
    before do
      fill_in 'comment_content', with: ''
      click_button 'Save changes'
    end
    it "does not save the changes" do
      expect(com.reload.content).not_to eql('')
    end
    it "renders errors" do
      expect(page).to have_content("can't be blank")
    end
  end

  context "with valid info" do
    before do
      fill_in 'comment_content', with: 'Updated content'
      click_button 'Save changes'
    end
    it "saves the changes" do
      expect(com.reload.content).to eql('Updated content')
    end
    it "redirects to the claim page" do
      expect(current_path).to eql(claim_path(cl))
    end
    it "displays the new comment info" do
      expect(page).to have_content("Updated content")
    end
  end

  describe "Deleting comments" do
    before { click_link 'Delete' }
    it "deletes the comment" do
      expect(Comment.find_by_id(com.id)).to be_nil
    end
    it "returns to the claim page" do
      expect(current_path).to eql(claim_path(cl))
    end
  end

end