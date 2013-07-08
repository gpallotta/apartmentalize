require 'spec_helper'

feature "marking claims as paid", %q{
  As a user
  I want to mark debts as paid
  so I can indicate when something has been paid off
} do

  # AC:
  # I can mark a debt as paid
  # I no longer see the debt in the list of unpaid debts
  # The debt's amount is no longer reflected in the totals people owe me
  # I no longer see the link to mark the debt as paid

  extend ClaimsHarness
  create_factories_and_sign_in

  scenario 'user marks claim paid on the index page' do
    visit claims_path
    click_link 'Mark paid'
    expect(cl.reload.paid).to be_true
    expect(current_path).to eql(claims_path)
  end

  scenario 'user marks claim paid on the show page' do
    visit claim_path(cl)
    expect(page).to have_link('Mark as paid',
        href: mark_as_paid_claim_path(cl))
    expect(page).to have_content('Unpaid')
    click_link 'Mark as paid'
    expect(cl.reload.paid).to be_true
    expect(current_path).to eql(claim_path(cl))
    expect(page).to have_content('Already paid')
    expect(page).not_to have_link('Mark as paid',
              href: mark_as_paid_claim_path(cl))
    expect(page).to have_content(cl.reload.paid_on.strftime("%B %d, %Y"))
  end

end
