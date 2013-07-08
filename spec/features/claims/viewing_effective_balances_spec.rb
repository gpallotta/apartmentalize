require 'spec_helper'

feature "viewing effective balances", %q{
  As a user, I want to
  see the effective balance between me and my roommates
  so we can easily zero out the balance between ourselves
} do

  # AC:
  # I can see the difference between what I am owed and what I owe for each roommate

  extend ClaimsHarness
  create_factories_and_sign_in

  scenario 'user views effective balances' do
    cl3 = FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user3,
        amount: 7)
    cl4 = FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user3,
        amount: 9.34)
    paid_cl = FactoryGirl.create(:claim, user_owed_to: user2,
        user_who_owes: user1, paid: true)
    visit claims_path
    expect(page).to have_content(cl.amount + paid_cl.amount - cl2.amount)
    expect(page).to have_content(cl3.amount + cl4.amount)
    expect(page).to have_content(cl.amount - cl2.amount + paid_cl.amount)
  end

end
