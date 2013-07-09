require 'spec_helper'

feature "searching claims", %q{
  As a user
  I want to be able to search through debts
  so I can look for specific information
} do

  # AC:
  # I can search on debt title
  # I can search on debt amount
  # I can search on debt paid status
  # I can search on roommates
  # I can combine search filters

  extend ClaimsHarness
  create_factories_and_sign_in

  before(:each) { visit claims_path }

  scenario 'user searches on title/description' do
    cl3 = FactoryGirl.create(:claim, user_owed_to: user1,
                      user_who_owes: user2, description: 'match desc')
    cl2.update_attributes(title: 'match title')
    fill_in 'z_title_or_description_cont', with: 'match'
    click_button 'Search Claims'
    expect(page).to have_content(cl2.title)
    expect(page).to have_content(cl3.title)
    expect(page).not_to have_content(cl.title)
  end

  scenario 'user searches on amount less than' do
    cl.update_attributes(amount: 3)
    fill_in 'z_amount_max', with: 5
    click_button 'Search Claims'
    expect(page).to have_content(cl.title)
  end

  scenario 'user searches on amount greater than' do
    cl.update_attributes(amount: 50)
    fill_in 'z_amount_min', with: 44
    click_button 'Search Claims'
    expect(page).to have_content(cl.title)
  end

  scenario 'user searches for an amount between' do
    cl.update_attributes(amount: 50)
    fill_in 'z_amount_min', with: 49
    fill_in 'z_amount_max', with: 51
    click_button 'Search Claims'
    expect(page).to have_content(cl.title)
    expect(page).not_to have_content(cl2.title)
  end

  scenario 'user searches for claims they owe' do
    check('To pay')
    click_button 'Search Claims'
    expect(page).to have_content(cl2.title)
    expect(page).not_to have_content(cl.title)
  end

  scenario 'user searches for claims they are owed' do
    check('To receive')
    click_button 'Search Claims'
    expect(page).to have_content(cl.title)
    expect(page).not_to have_content(cl2.title)
  end

  scenario 'user searches for both claims they owe and are owed' do
    check('To pay')
    check('To receive')
    click_button 'Search Claims'
    expect(page).to have_content(cl.title)
    expect(page).to have_content(cl2.title)
  end

  scenario 'user searches for claims related to a certain user' do
    cl3 = FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user3)
    within('.claim-search-form') { check "#{user3.id}-checkbox" }
    click_button 'Search Claims'
    expect(page).to have_content(cl3.title)
    expect(page).not_to have_content(cl.title)
    expect(page).not_to have_content(cl2.title)
  end

  scenario 'user searches for paid claims' do
    cl.update_attributes(paid: true)
    check('paid-checkbox')
    click_button 'Search Claims'
    expect(page).to have_content(cl.title)
    expect(page).not_to have_content(cl2.title)
  end

  scenario 'user searches for unpaid claims' do
    cl.mark_as_paid
    check('unpaid-checkbox')
    click_button 'Search Claims'
    expect(page).to have_content(cl2.title)
    expect(page).not_to have_content(cl.title)
  end

  scenario 'user searches for both paid and unpaid claims' do
    cl.update_attributes(paid: true)
    check('paid-checkbox')
    check('unpaid-checkbox')
    click_button 'Search Claims'
    expect(page).to have_content(cl.title)
    expect(page).to have_content(cl2.title)
  end

  scenario 'user searches by min date paid' do
    cl2.paid_on, cl2.created_at, cl2.paid = 5.days.ago, 5.days.ago, true
    cl2.save
    cl3 = FactoryGirl.create(:claim, user_owed_to: user1, paid: true,
        user_who_owes: user2, paid_on: 7.days.ago, created_at: 7.days.ago)
    fill_in 'datepicker-paid-min', with: 6.days.ago.strftime("%m/%d/%Y")
    click_button 'Search Claims'
    expect(page).to have_content(cl2.title)
    expect(page).not_to have_content(cl3.title)
  end

  scenario 'user searches by max date paid' do
    cl2.paid_on, cl2.created_at, cl2.paid = 5.days.ago, 5.days.ago, true
    cl2.save
    cl3 = FactoryGirl.create(:claim, user_owed_to: user1, paid: true,
        user_who_owes: user2, paid_on: 7.days.ago, created_at: 7.days.ago)
    fill_in 'datepicker-paid-max', with: 6.days.ago.strftime("%m/%d/%Y")
    click_button 'Search Claims'
    expect(page).to have_content(cl3.title)
    expect(page).not_to have_content(cl2.title)
  end

  scenario 'user searches by both min and max date paid' do
    cl2.paid_on, cl2.created_at, cl2.paid = 5.days.ago, 5.days.ago, true
    cl2.save
    cl3 = FactoryGirl.create(:claim, user_owed_to: user1, paid: true,
        user_who_owes: user2, paid_on: 7.days.ago, created_at: 7.days.ago)

    fill_in 'datepicker-paid-min', with: 8.days.ago.strftime("%m/%d/%Y")
    fill_in 'datepicker-paid-max', with: 6.days.ago.strftime("%m/%d/%Y")
    click_button 'Search Claims'
    expect(page).to have_content(cl3.title)
    expect(page).not_to have_content(cl2.title)
  end

  scenario 'user searches on min date created' do
    cl2.paid_on, cl2.created_at = 5.days.ago, 5.days.ago
    cl2.save
    cl3 = FactoryGirl.create(:claim, user_owed_to: user1,
        user_who_owes: user2, created_at: 7.days.ago)
    fill_in 'datepicker-created-min', with: 6.days.ago.strftime("%m/%d/%Y")
    click_button 'Search Claims'
    expect(page).to have_content(cl2.title)
    expect(page).not_to have_content(cl3.title)
  end

  scenario 'user searches on max date created' do
    cl2.paid_on, cl2.created_at = 5.days.ago, 5.days.ago
    cl2.save
    cl3 = FactoryGirl.create(:claim, user_owed_to: user1,
        user_who_owes: user2, created_at: 7.days.ago)
    fill_in 'datepicker-created-max', with: 6.days.ago.strftime("%m/%d/%Y")
    click_button 'Search Claims'
    expect(page).to have_content(cl3.title)
    expect(page).not_to have_content(cl2.title)
  end

  scenario 'user searches on both min and max date created' do
    cl2.paid_on, cl2.created_at = 5.days.ago, 5.days.ago
    cl2.save
    cl3 = FactoryGirl.create(:claim, user_owed_to: user1,
        user_who_owes: user2, created_at: 7.days.ago)
    fill_in 'datepicker-created-min', with: 8.days.ago.strftime("%m/%d/%Y")
    fill_in 'datepicker-created-max', with: 6.days.ago.strftime("%m/%d/%Y")
    click_button 'Search Claims'
    expect(page).to have_content(cl3.title)
    expect(page).not_to have_content(cl2.title)
  end

  scenario 'user resets a search' do
    fill_in 'z_title_or_description_cont', with: 'sfsdsdfl'
    click_button 'Search Claims'
    click_link 'Clear'
    expect(page).to have_content(cl.title)
    expect(page).to have_content(cl2.title)
  end

  scenario 'user performs two searches consecutively' do
    fill_in 'z_title_or_description_cont', with: 'match'
    fill_in 'z_amount_min', with: 1
    fill_in 'z_amount_max', with: 2
    check("#{user3.id}-checkbox")
    check("paid-checkbox")
    check("unpaid-checkbox")
    check("To receive")
    check("To pay")
    click_button 'Search Claims'
    expect( find_field('z_title_or_description_cont').value).to eql 'match'
    expect( find_field('z_amount_min').value).to eql '1'
    expect( find_field('z_amount_max').value).to eql '2'
    expect( find("##{user3.id}-checkbox") ).to be_checked
    expect( find("#paid-checkbox") ).to be_checked
    expect( find("#unpaid-checkbox") ).to be_checked
    expect( find("#to-receive") ).to be_checked
    expect( find("#to-pay") ).to be_checked
  end

end
