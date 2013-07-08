require 'spec_helper'

feature 'user views about page' do

  scenario "user visits about page" do
    visit welcome_page_path
    click_link 'About'
    expect(page).to have_content('About this site')
  end

end
