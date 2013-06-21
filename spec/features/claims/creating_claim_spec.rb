require 'spec_helper'

feature 'user creates claim', %q{
  As a user
  I want to create new claim
  so I can keep track of items I am owed for
} do

# AC:
# * I can create a claim
# * I can set who owes the claim
# * I can give the claim a title
# * I can give the claim a description
# * I can give the claim an amount

  extend ClaimsHarness
  create_factories_and_sign_in

  before(:each) { visit claims_path }

  scenario 'user creates claim with invalid info' do
    expect { click_button 'Create Claim' }.not_to change {Claim.count}
  end

  scenario 'user creates claim with valid info for all users' do
    fill_in 'claim_title', with: 'Test'
    fill_in 'claim_amount', with: 5
    expect { click_button 'Create Claim' }.to change { Claim.count }.by(2)
    expect(Claim.last.amount).to eql(5)
    expect(page).to have_content('Test')
    expect(page).to have_content(5)
  end

  scenario 'user creates claim with valid info for some users' do
    fill_in 'claim_title', with: 'Test'
    fill_in 'claim_amount', with: 5
    find(:css, "##{user2.name}").set(false)
    expect { click_button 'Create Claim' }.to change {Claim.count }.by(1)
    expect(Claim.last.amount).to eql(5)
  end

  scenario 'user users autosplit feature to alter claim amount' do
    fill_in 'claim_title', with: 'Split'
    fill_in 'claim_amount', with: 6
    find(:css, "##{user3.name}").set(false)
    check('Split evenly')
    before_count = Claim.count
    click_button 'Create Claim'
    expect(Claim.last.amount).to eql(3.0)
  end

end
