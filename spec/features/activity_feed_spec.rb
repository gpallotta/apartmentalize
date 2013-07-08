require 'spec_helper'

feature 'activity feed', %q{
  As a user
  I want to see a feed of recent activity on the site
  so I know what has been going on
} do


  # AC:
  # I see a feed of the most recent activity
  # The feed includes creating and deleting debts, marking paid, and commenting
  # I do not see my activity on the news feed
  # Items which are older are not displayed
  # I do not see items not related to me listed in the feed

  let(:group) { FactoryGirl.create(:group) }
  let!(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:user3) { FactoryGirl.create(:user, group: group) }

  before(:each) { sign_in user2 }

  scenario 'activity not related to the user' do
    c = FactoryGirl.create(:claim, user_owed_to: user2, user_who_owes: user3)
    visit claim_path(c)
    fill_in 'comment_content', with: 'Not related'
    click_button 'Comment'
    switch_to_user1
    expect(page).not_to have_content("#{user2.name} commented on")
  end

  scenario "the current user's activity" do
    title = 'My own activity'
    visit claims_path
    create_claim(title, 5)
    visit user_root_path
    expect(page).not_to have_content("#{user2.name} created a new claim for #{title}")
  end

  scenario 'claim created for the user' do
    visit claims_path
    create_claim('Test', 5)
    switch_to_user1
    c = Claim.find_by_title('Test')
    expect(page).to have_content("#{user2.name} created a new claim")
    expect(page).to have_link( "#{c.title}", href: claim_path(c) )
  end

  scenario "a user's claim is commented on" do
    c = FactoryGirl.create(:claim, user_owed_to: user2, user_who_owes: user1)
    visit claim_path(c)
    fill_in 'comment_content', with: 'Test'
    click_button 'Comment'
    switch_to_user1
    expect(page).to have_content("#{user2.name} commented on")
    expect(page).to have_link("#{c.title}", href: claim_path(c))
  end

  scenario "claim owed by user is marked paid" do
    c = FactoryGirl.create(:claim, user_owed_to: user2, user_who_owes: user1)
    visit claims_path
    click_link 'Mark paid'
    switch_to_user1
    expect(page).to have_content("#{user2.name} marked #{c.title} as paid")
  end

  scenario "activity feed item is deleted" do
    visit claims_path
    create_claim('Delete me', 5)
    user1.claims_to_pay.last.destroy
    switch_to_user1
    expect(page).to have_content("#{user2.name} deleted this claim")
  end

  scenario 'more than 10 items on activity feed' do
    visit claims_path
    11.times do |i|
      create_claim("Title #{i}", 1)
    end
    switch_to_user1
    expect(page).not_to have_content("#{user2.name} created a new claim for Title 0")
  end


  def switch_to_user1
    sign_out user2
    sign_in user1
  end

  def create_claim(title, amount)
    fill_in 'claim_title', with: title
    fill_in 'claim_amount', with: amount
    click_button 'Create Claim'
  end

end
