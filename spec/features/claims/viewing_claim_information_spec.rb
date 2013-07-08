require 'spec_helper'

feature 'viewing claim information', %q{
  As a user
  I want to see the information about a claim
  so I can tell what each claim is for
} do

  # AC:
  # I can see the name of a claim
  # I can see the title
  # I can see the description
  # I can see the amount
  # I can see who owes it
  # I cannot see claims between my roommates
  # I cannot see claims from other groups

  extend ClaimsHarness
  create_factories_and_sign_in

  scenario 'user views claims on index page' do
    roommate_cl = FactoryGirl.create(:claim,
        user_owed_to: user3, user_who_owes: user2)
    paid_cl = FactoryGirl.create(:claim, user_owed_to: user1,
        user_who_owes: user2, paid: true)
    visit claims_path
    expect(page).to have_content(cl.title)
    expect(page).not_to have_content(paid_cl.title)
    expect(page).not_to have_content(roommate_cl.title)
    expect(page).not_to have_link('Mark paid', href: mark_as_paid_claim_path(cl2))
  end

  scenario 'user trys to view more than 25 claims on a page' do
    cl.update_attributes(title: 'paginated')
    cl3 = FactoryGirl.create(:claim, user_owed_to: user1,
        user_who_owes: user2, amount: 35)
    25.times do
      FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2)
    end
    visit claims_path
    expect(page).not_to have_content(cl.title)
    expect(page).to have_link('2')

    cl.update_attributes(amount: 1)
    cl2.update_attributes(amount: 3)
    Claim.last.update_attributes(amount: 30)
    last_claim = Claim.last
    visit claims_path
    click_link 'Amount'
    expect(page.body.index(cl.title)).to be < page.body.index(cl2.title)
    click_link '2'
    expect(page.body.index(last_claim.title)).to be < page.body.index(cl3.title)
  end

end
