require 'spec_helper'

feature 'user sends donation', %q{
  As a user
  I want to send a donation to Greg
  so I can give him money for his excellent work
} do

  # AC
  # * I can specify a donation amount to send
  # * The donation is only sent once
  # * I am notified that the donation has been sent
  # * I must be logged in to send a donation

  let!(:user) { FactoryGirl.create(:user) }
  # before { sign_in user }

  scenario 'unauthenticated user visits donations page' do
    # sign_out user
    visit new_donation_path
    expect(current_path).to eql new_user_session_path
  end

  scenario 'authenticated user sends a donation', :js => true do
    before_count = Donation.count
    # VCR.use_cassette 'new_donation' do
      visit welcome_page_path
      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_button 'Sign in'
      visit new_donation_path
      fill_in 'donation_email', with: 'greg@greg.com'
      fill_in 'donation_name', with: 'greg'
      fill_in 'donation_amount', with: 5
      fill_in 'card_number', with: '4242424242424242'
      fill_in 'card_code', with: '123'
      select '2014', from: 'card_year'
      select 'January', from: 'card_month'
      click_button 'Donate'

    # end
    expect(Donation.count).to eql(before_count+1)
  end

  scenario 'authenticated user sends a donation with invalid info'

end
