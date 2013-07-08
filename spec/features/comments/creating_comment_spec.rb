require 'spec_helper'

feature 'creating comments', %q{
  As a user
  I want to be able to comment on a debt
  so I can ask questions about it
} do

  # AC:
  # I can write a comment on a debt
  # I can see my roommates comments
  # I am notified when someone comments on my debt or a debt I have commented on

  extend CommentsHarness
  create_factories_and_sign_in

  before(:each) { visit claim_path(cl) }


  scenario 'user creates comment with valid info' do
    fill_in 'comment_content', with: 'hello_from_comment'
    before_count = Comment.count
    click_button 'Comment'
    expect(before_count).to eql(Comment.count-1)
    expect(page).to have_content('hello_from_comment')
  end

  scenario 'user creates comment with no content' do
    expect { click_button 'Comment' }.not_to change { Comment.count }
    expect(page).to have_content("can't be blank")
  end

end
