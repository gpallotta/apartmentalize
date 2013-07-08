require 'spec_helper'

feature 'viewing comments', %q{
  As a user
  I want to be able to view information about a comment
  so I can see who posted it when
} do

  # AC:
  # I can see all comments for a particular claim
  # I can see who wrote the comment
  # I can see when the comment was posted

  extend CommentsHarness
  create_factories_and_sign_in

  scenario 'user views a comment' do
    com2 = FactoryGirl.create(:comment, user: user2, claim: cl)
    visit claim_path(cl)
    expect(page).to have_content(com.content)
    expect(page).to have_content(com2.content)
    expect(page).to have_content(com.user.name)
    expect(page).to have_content(com2.user.name)
    expect(page.body.index(com.content)).to be < page.body.index(com2.content)
  end

end
