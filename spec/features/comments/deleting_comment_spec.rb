require 'spec_helper'

feature 'deleting comments', %q{
  As a user
  I want to delete my comments
  so I can remove ones I created erroneously
} do

  # AC
  # I can delete my comments
  # The comments are no longer displayed

  extend CommentsHarness
  create_factories_and_sign_in

  scenario 'user deletes a comment they created' do
    visit claim_path(cl)
    click_link 'Edit Comment'
    click_link 'Delete'
    expect(Comment.find_by_id(com.id)).to be_nil
    expect(current_path).to eql(claim_path(cl))
  end

end
