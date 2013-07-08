require 'spec_helper'

feature "editing claims", %q{
  As a user
  I want to edit debts
  so I can correct erroneous information
} do

  # AC:
  # I can edit a debt
  # The new amount and title are reflected on the view pages

  extend ClaimsHarness
  create_factories_and_sign_in

  before(:each) do
    visit claim_path(cl)
    click_link 'Edit'
  end

  scenario 'user edits claim with valid new info' do
    fill_in 'claim_title', with: 'Updated title'
    click_button 'Save changes'
    expect(cl.reload.title).to eql("Updated title")
    expect(page).to have_content('Updated title')
    expect(current_path).to eql(claim_path(cl))
  end

  scenario 'user edits claim with invalid new info' do
    fill_in 'claim_amount', with: 'String'
    click_button 'Save changes'
    expect(cl.reload.amount).not_to eql('String')
    expect(current_path).to eql( "/claims/#{cl.id}" )
  end

end
