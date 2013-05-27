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
          before(:each) {  click_button 'Create New Group' }

          it "creates a group" do
            expect(Group.count).not_to eql(0)
          end
          it "generates a default" do
            expect(Group.first.identifier).not_to be_blank
          end

        end

        context "providing an identifier to use" do

          context "When the identifier has been taken" do
            let!(:before_group_count) { Group.count }
            before do
              Group.create(identifier: 'i_am_taken')
              fill_in 'group_identifier', with: 'i_am_taken'
              click_button 'Create New Group'
            end
            let!(:after_group_count) { Group.count }

            it "does not create a new group" do
              expect(before_group_count+1).to eql(after_group_count)
            end

            it "redirects back to the new group path" do
              expect(current_path).to eql(groups_path)
            end

            it "renders errors" do
              should have_content('has already been taken')
            end

          end

          context "when the identifier has not been taken" do
            before do
              fill_in 'group_identifier', with: 'asdfghjkl'
            end

            it "creates a new group" do
              expect { click_button 'Create New Group' }.to change { Group.count }.by(1)
            end

            it "sets the identifier to the provided string" do
              click_button 'Create New Group'
              should have_content('asdfghjkl')
            end
            it "takes the user to the registration page" do
              click_button 'Create New Group'
              expect(current_path).to eql(new_user_registration_path)
            end
          end

        end
      end

    end # end for setting up group

    describe "then creating a user" do

      before do
        fill_in 'group_identifier', with: 'user_tests'
        click_button 'Create New Group'
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
        end

        it "sets up the group association" do
          click_button 'Sign up'
          expect(User.first.group).not_to be(nil)
          expect(User.first.group.identifier).to eql('user_tests')
        end

      end

      context "with invalid information" do

        it "does not create a user" do
          expect { click_button 'Sign up' }.not_to change { User.count }
        end

        it "redirects back to the user signup page" do
          click_button 'Sign up'
          expect(current_path).to eql(user_registration_path)
        end

        it "renders errors" do
          click_button 'Sign up'
          should have_content("Name can't be blank")
          should have_content("Email can't be blank")
          should have_content("Password can't be blank")
        end

      end

    end

  end # end for signing up



end
