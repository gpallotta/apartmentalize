require 'spec_helper'

feature 'editing comments', %q{
  As a user
  I want to be able to edit my comments on claims
  so that I can correct any erroneous entries
} do

  # AC:
  # I can edit a comment
  # The new information is reflected in the show page
  # I can delete comments
  # I can only edit my own comments

  extend CommentsHarness
  create_factories_and_sign_in

  before(:each) do
    visit claim_path(cl)
    click_link 'Edit Comment'
  end

  scenario 'user edits comment with valid new info' do
    fill_in 'comment_content', with: 'Updated content'
    click_button 'Save changes'
    expect(com.reload.content).to eql('Updated content')
    expect(current_path).to eql(claim_path(cl))
    expect(page).to have_content("Updated content")
  end

  scenario 'user edits comment with invalid new info' do
    fill_in 'comment_content', with: ''
    click_button 'Save changes'
    expect(com.reload.content).not_to eql('')
    expect(page).to have_content("can't be blank")
  end

  scenario 'user views edit link for a claim they owe' do
    com2 = FactoryGirl.create(:comment, user: user2, claim: cl)
    visit claim_path(cl)
    expect(page).not_to have_link("Edit Comment", href: edit_comment_path(com2))
  end

end
