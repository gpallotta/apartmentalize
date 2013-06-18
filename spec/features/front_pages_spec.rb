require 'spec_helper'

feature "user sees info on front page", %q{
  As a user
  I want to see a list of important info on the front page
  so that I can quickly get information
} do

  # AC:
  # I see my current chore on the front page
  # I see balances between my roommates and I

  extend ClaimsHarness
  create_factories_and_sign_in
  let!(:chore) { FactoryGirl.create(:chore, user: user1)}
  let!(:unrelated_chore) { FactoryGirl.create(:chore, user: user2)}
  let!(:cl3) { FactoryGirl.create(:claim, user_owed_to: user1,
                user_who_owes: user3, amount: 5.5) }

  scenario 'user visits front page' do
    visit home_page_path
    expect(page).to have_content(chore.title)
    expect(page).not_to have_content(unrelated_chore.title)
    expect(page).to have_content("Balance for #{user2.name}")
    expect(page).to have_content("Balance for #{user3.name}")
    expect(page).to have_content(cl.amount - cl2.amount)
    expect(page).to have_content(cl3.amount)
  end

end
