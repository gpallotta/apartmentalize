###############

# As a user
# I want to be able to comment on a debt
# so I can ask questions about it

# AC:
# I can write a comment on a debt
# I can see my roommates comments
# I am notified when someone comments on my debt or a debt I have commented on

###############

require 'spec_helper'


describe "creating comments" do

  extend CommentsHarness
  create_factories_and_sign_in

  before { visit claim_path(cl) }


  context "with invalid info" do
    it "does not create a comment" do
      expect { click_button 'Comment' }.not_to change { Comment.count }
      expect(page).to have_content("can't be blank")
    end
  end

  context "with valid info" do
    before { fill_in 'comment_content', with: 'hello_from_comment' }
    it "creates a comment" do
      before_count = Comment.count
      click_button 'Comment'
      expect(before_count).to eql(Comment.count-1)
      expect(page).to have_content('hello_from_comment')
    end
  end
end
