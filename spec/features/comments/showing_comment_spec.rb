require 'spec_helper'

describe "viewing comments" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:cl) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2)}
  let!(:com) { FactoryGirl.create(:comment, claim: cl, user: user1)}

  before do
    sign_in user1
    visit claim_path(cl)
  end

  let!(:com2) { FactoryGirl.create(:comment, user: user2, claim: cl) }

  before { visit claim_path(cl) }
  it "shows all comments for the claim" do
    expect(page).to have_content(com.content)
    expect(page).to have_content(com2.content)
  end
  it "shows who wrote the comment" do
    expect(page).to have_content(com.user.name)
    expect(page).to have_content(com2.user.name)
  end
  it "shows comments with the oldest first" do
    expect(page.body.index(com.content)).to be < page.body.index(com2.content)
  end
  it "only shows edit links for your comments" do
    expect(page).not_to have_link("Edit Comment", href: edit_comment_path(com2))
  end

end
