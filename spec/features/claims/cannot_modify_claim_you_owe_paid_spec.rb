require 'spec_helper'

feature 'editing claims you did not create', %q{
  As a user
  I do not want to be able to modify claims I owe to others as paid
  so my roommates can't scam me
} do

  # AC
  # I cannot mark debts that I owe as paid
  # I can still mark debts that others owe me as paid

  extend ClaimsHarness
  create_factories_and_sign_in

  scenario 'user attempts to mark paid claim they owe on index page' do
    visit claims_path
    expect(page).not_to have_link('Mark as paid',
          href: mark_as_paid_claim_path(cl2) )
  end

  scenario 'user attempts to mark paid claim they owe on show page' do
    visit claim_path(cl2)
    expect(page).not_to have_link('Mark as paid',
          href: mark_as_paid_claim_path(cl2))
  end

  scenario 'user attempts to edit claim they owe' do
    visit claim_path(cl2)
    expect(page).not_to have_link('Edit', href: edit_claim_path(cl2) )
  end

end
