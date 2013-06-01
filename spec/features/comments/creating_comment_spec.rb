require 'spec_helper'


describe "creating comments" do

  extend CommentsHarness
  create_factories_and_sign_in

  before { visit claim_path(cl) }


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
