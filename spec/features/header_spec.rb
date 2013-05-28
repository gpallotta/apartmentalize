require 'spec_helper'

describe "header" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user) { FactoryGirl.create(:user, group: group) }

  before { sign_in user }
  subject { page }

  describe "links" do

    context "sign out" do
      it "has a sign out link" do
        should have_link('Sign out', href: destroy_user_session_path)
      end
      it "signs out the user" do
        click_link 'Sign out'
        expect(current_path).to eql(root_path)
        should have_button('Sign in')
      end
    end

    context "chores" do
      it "has a chores link" do
        should have_link('Chores', href: chores_path)
      end
      it "takes you to the chores index page" do
        click_link 'Chores'
        expect(current_path).to eql(chores_path)
      end
    end

    context 'debts' do
      it "has a debts link" do
        should have_link 'Debts', href: debts_path
      end
      it "takes you to the debts index page" do
        click_link 'Debts'
        expect(current_path).to eql(debts_path)
      end
    end

  end

end
