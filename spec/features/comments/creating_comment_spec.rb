require 'spec_helper'


describe "creating comments" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:cl) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2)}

  before do
    sign_in user1
    visit claim_path(cl)
  end


  context "with invalid info" do
    it "does not create a comment" do
      expect { click_button 'Comment' }.not_to change { Comment.count }
    end
    it "renders errors" do
      click_button 'Comment'
      expect(page).to have_content("can't be blank")
    end
  end

  context "with valid info" do
    before { fill_in 'comment_content', with: 'hello_from_comment' }
    it "creates a comment" do
      before_count = Comment.count
      click_button 'Comment'
      expect(before_count).to eql(Comment.count-1)
    end
    it "displays the comment" do
      click_button 'Comment'
      expect(page).to have_content('hello_from_comment')
    end
  end
end
