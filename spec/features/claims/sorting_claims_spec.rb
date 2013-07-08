require 'spec_helper'

feature "sorting claims", %q{
  As a user
  I want to sort the display of debts
  so I can view the information how I want
} do

  # AC:
  # I can sort the display of debts by amount
  # I can sort the display of debts by date created
  # I can sort the display of debts by title

  extend ClaimsHarness
  create_factories_and_sign_in

  before(:each) { visit claims_path }

  scenario 'user sorts by paid status' do
    cl2.update_attributes(paid: true)
    click_button 'Search Claims'
    click_link 'Paid'
    expect(page.body.index(cl.title)).to be < page.body.index(cl2.title)
    click_link 'Paid'
    expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
  end

  scenario 'user sorts by user owed to' do
    click_link 'Owed to'
    expect(page.body.index(cl.title)).to be < page.body.index(cl2.title)
    click_link 'Owed to'
    expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
  end

  scenario 'user sorts by user who owes' do
    click_link 'Owed by'
    expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
    click_link 'Owed by'
    expect(page.body.index(cl.title)).to be < page.body.index(cl2.title)
  end

  scenario 'user sorts by title' do
    cl2.update_attributes(title: 'aaaa')
    click_link 'Title'
    expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
    click_link 'Title'
    expect(page.body.index(cl.title)).to be < page.body.index(cl2.title)
  end

  scenario 'user sorts by amount' do
    cl2.update_attributes(amount: 10)
    click_link 'Amount'
    expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
    click_link 'Amount'
    expect(page.body.index(cl2.title)).to be > page.body.index(cl.title)
  end

  scenario 'user sorts by date created' do
    old_claim = FactoryGirl.create(:claim, user_owed_to: user1,
        user_who_owes: user2, created_at: 1.day.ago, title: 'old title')
    visit claims_path
    expect(page.body.index(cl.title)).to be < page.body.index(old_claim.title)
    click_link 'Created on'
    expect(page.body.index(old_claim.title)).to be < page.body.index(cl.title)
  end

  scenario 'user performs a search and then sorts' do
    larger_cl = FactoryGirl.create(:claim, user_owed_to: user1,
        user_who_owes: user2, amount: 4)
    smaller_cl = FactoryGirl.create(:claim, user_owed_to: user1,
        user_who_owes: user2, amount: 2)
    visit claims_path
    fill_in 'z_amount_max', with: 5
    click_button 'Search Claims'
    click_link 'Amount'
    expect( page.body.index(smaller_cl.title) ).
          to be < page.body.index(larger_cl.title)
    expect(page).not_to have_content(cl.title)
  end

  scenario 'user attempts to sort by a non-valid criteria' do
    visit '/claims?direction=crap&sort=morecrap'
    expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
  end

end
