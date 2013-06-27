require 'spec_helper'

feature 'user views about page' do

  it "shows some info about the site" do
    visit welcome_page_path
    click_link 'About'
    expect(page).to have_content('About this site')
  end

end
