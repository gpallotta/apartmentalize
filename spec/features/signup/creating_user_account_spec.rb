###############

# As a user
# I want to create an account on the site
# so I can use and store my own information

# AC:
# I can create a user account
# The account is unique to me
# The account is associated with a particular group

###############

require 'spec_helper'

describe "creating a user" do

  let!(:group) { FactoryGirl.create(:group) }

  before do
    visit new_group_path
    fill_in 'lookup_identifier', with: group.identifier
    click_button 'Lookup'
  end

  context "with valid information" do
    before do
      fill_in 'user_name', with: 'Valid name'
      fill_in 'user_email', with: 'valid@email.com'
      fill_in 'user_password', with: '12345678'
      fill_in 'user_password_confirmation', with: '12345678'
    end

    it "creates the user" do
      expect { click_button 'Sign up' }.to change { User.count }.by(1)
      expect(User.last.group).not_to be(nil)
      expect(User.last.group.identifier).to eql(group.identifier)
    end

  end

  context "with invalid information" do

    context "when the name has been taken within the group" do
      let!(:named_user) { FactoryGirl.create(:user, group: group,
                            name: 'taken')}

      it "does not create the user" do
        visit new_group_path
        fill_in 'lookup_identifier', with: group.identifier
        click_button 'Lookup'
        fill_in 'user_name', with: named_user.name
        expect { click_button 'Sign up' }.not_to change { User.count }
        expect(page).to have_content('Name has already been taken')
      end

    end

    context "when fields are missing" do
      it "does not create the user" do
        expect { click_button 'Sign up' }.not_to change { User.count }
        expect(current_path).to eql(user_registration_path)
        expect(page).to have_content("Name can't be blank")
        expect(page).to have_content("Email can't be blank")
        expect(page).to have_content("Password can't be blank")
      end
    end

  end
end
