require 'spec_helper'

describe "unauthenticated pages" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user) { FactoryGirl.create(:user, group: group) }

  before { visit root_path }
  subject { page }

  describe "resetting password" do

    before { click_link 'Forgot your password?'}

    describe "then clicking on the sign up link" do

      it "directs you to the new group page" do
        click_link 'Sign up'
        current_path.should eql(new_group_path)
      end
    end

  end

  describe "signing in" do


    context "with invalid information" do
      before { click_button 'Sign in' }

      it "redirects to new session path" do
        current_path.should == new_user_session_path
      end

      describe "then clicking on the sign up link" do
        it "directs you to the new group page" do
          click_link 'Sign up'
          current_path.should eql(new_group_path)
        end
      end

    end

    context "with valid information" do

      before do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        click_button 'Sign in'
      end

      it "signs in the user" do
        pending
      end
    end
  end

  describe "signing up" do

    before { click_link 'Sign up' }

    it "directs to the new group page" do
      current_path.should eql(new_group_path)
    end

    describe "setting up group" do

      context "with existing group" do
        pending
      end

      context "with new group" do
        context "providing no identifier and using default" do
          pending
        end

        context "providing an identifier to use" do
          pending
        end
      end

    end # end for setting up group

    describe "then creating a user" do

      context "with invalid information" do
        pending
      end

      context "with valid information" do
        pending
      end

    end

  end # end for signing up


end
