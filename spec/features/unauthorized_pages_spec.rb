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
        should have_link('Sign out')
        expect(current_path).to eql(root_path)
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

        context "when the identifier exists" do

          before do
            FactoryGirl.create(:group, identifier: 'exists')
            fill_in 'lookup_identifier', with: 'exists'
            click_button 'Lookup'
          end

          it "displays the group identifier on the page" do
            should have_content('exists')
          end

          context "then creating a user" do

            before do
              fill_in 'user_name', with: 'Valid name'
              fill_in 'user_email', with: 'valid@email.com'
              fill_in 'user_password', with: '12345678'
              fill_in 'user_password_confirmation', with: '12345678'
            end

            it "creates the user" do
              expect { click_button 'Sign up' }.to change { User.count }.by(1)
            end

            it "sets up the group association" do
              click_button 'Sign up'
              expect(User.first.group).not_to be(nil)
              expect(User.first.group.identifier).to eql('exists')
            end

          end

        end

        context "when the identifier does not exist" do

          before do
            fill_in 'lookup_identifier', with: 'not here'
            click_button 'Lookup'
          end

          it "brings the user back to the new group page" do
            should have_content("Join existing group")
          end

          it "renders errors" do
            should have_content("Group not found")
          end

        end

      end

      context "with new group" do

        context "providing no identifier and using default" do

          it "creates a group" do
            expect { click_button 'Create New Group' }.to change {Group.count}.by(1)
          end
          it "generates a default" do
            pending
          end
        end

        context "providing an identifier to use" do

          context "When the identifier has been taken" do
            pending
          end

          context "when the identifier has not been taken" do
            it "creates a new group" do
            end

            it "sets the identifier to the provided string" do
            end
          end

        end
      end

    end # end for setting up group

    describe "then creating a user" do

      context "with invalid information" do

        context "with no name" do
        end

        context "with no email" do
        end

        context "when password has been taken" do
        end

        context "with password not matching confirmation" do
        end

      end

      context "with valid information" do
        pending
      end

    end

  end # end for signing up


end
