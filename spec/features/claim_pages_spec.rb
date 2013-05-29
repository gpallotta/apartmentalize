require 'spec_helper'

describe "claim pages" do

  let(:group) { FactoryGirl.create(:group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:user3) { FactoryGirl.create(:user, group: group) }
  let!(:cl) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2)}

  before do
    sign_in user1
    visit claims_path
  end

  subject { page }

  describe "claims index page" do

    describe "viewing claims" do
      let!(:cl2) { FactoryGirl.create(:claim, user_owed_to: user2, user_who_owes: user1)}
      let!(:cl3) { FactoryGirl.create(:claim, user_owed_to: user1,
                      user_who_owes: user1, paid: true)}
      before { visit claims_path }

      it "displays all unpaid claims related to you by default" do
        expect(page).to have_content(cl.title)
        expect(page).to have_content(cl2.title)
        expect(page).not_to have_content(cl3.title)
      end
      it "displays the title of a claim" do
        expect(page).to have_content(cl.title)
      end
      it "displays the amount of a claim" do
        expect(page).to have_content(cl.amount)
      end
      it "has a link to view a single debt" do
        expect(page).to have_link('View', href: claim_path(cl))
      end
      it "has a link to mark a debt as paid" do
        expect(page).to have_link('Mark paid', href: mark_as_paid_claim_path(cl))
      end
    end

    describe "searching claims" do
      let!(:cl3) { FactoryGirl.create(:claim, user_owed_to: user1,
                    user_who_owes: user1, paid: true)}

      context "searching by title or description" do
        let!(:cl_title) { FactoryGirl.create(:claim, user_owed_to: user1,
                          user_who_owes: user2, title: 'match')}
        let!(:cl_desc) { FactoryGirl.create(:claim, user_who_owes: user1,
                          user_owed_to: user2, description: 'match')}
        before do
          fill_in 'q_title_or_description_cont', with: 'match'
          click_button 'Search'
        end

        it "only returns results which match the string" do
          expect(page).to have_content(cl_title.title)
          expect(page).to have_content(cl_title.title)
          expect(page).not_to have_content(cl3.title)
        end
      end

      context "searching by amount" do
        let!(:cl_amount) { FactoryGirl.create(:claim, user_owed_to: user1,
                          user_who_owes: user2, amount: 3)}

        context "less than" do
          before do
            fill_in 'q_amount_lteq', with: 5
            click_button 'Search'
          end
          it "only returns results which match the amounts" do
            expect(page).to have_content(cl_amount.title)
          end
        end

        context "greater than" do
          let!(:cl_amount) { FactoryGirl.create(:claim, user_owed_to: user1,
                          user_who_owes: user2, amount: 45)}
          before do
            fill_in 'q_amount_gteq', with: 44
            click_button 'Search'
          end
          it "only returns results which match the amounts" do
            expect(page).to have_content(cl_amount.title)
          end
        end
      end

      context "including paid claims" do
        before do
          check('include_paid')
          click_button 'Search'
        end
        it "includes both paid and unpaid claims in the results" do
          expect(page).to have_content(cl3.title)
          expect(page).to have_content(cl.title)
        end
      end

    end # end for searching claims

    describe "marking claims as paid" do
      let!(:cl) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2)}
      before { visit claims_path }

      it "marks the debt as paid" do
        click_link 'Mark paid'
        expect(cl.reload.paid).to be_true
      end
    end

    describe "creating claims" do

      context "with invalid info" do
        it "does not create a claim" do
          expect { click_button 'Create Claim' }.not_to change {Claim.count}
        end
      end

      context "with valid info" do

        before do
          fill_in 'claim_title', with: 'Test'
          fill_in 'claim_amount', with: 5
        end

        context "for all other users" do

          it "creates a claim for all users" do
            expect { click_button 'Create Claim' }.to change { Claim.count }.by(2)
          end
          it "displays the new claims" do
            click_button 'Create Claim'
            should have_content('Test')
            should have_content(5)
          end

        end

        context "for only some users" do
          before { uncheck "#{user2.name}" }
          it "creates the debt for only the checked users" do
            expect { click_button 'Create Claim' }.to change {Claim.count }.by(1)
          end
        end
      end

    end

  end


  describe "view page for a single claim" do
    describe "editing claims" do

      let!(:cl) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2)}
      before do
        visit claim_path(cl)
        click_link 'Edit'
      end

      context "with invalid info" do
        before do
          fill_in 'claim_amount', with: 'String'
          click_button 'Save changes'
        end

        it "does not save the updated info" do
          expect(cl.reload.amount).not_to eql('String')
        end
        it "re-renders the edit page" do
          expect(current_path).to eql( "/claims/#{cl.id}" )
        end
      end

      context "with valid info" do
        before do
          fill_in 'claim_title', with: 'Updated title'
          click_button 'Save changes'
        end

        it "saves the changes" do
          expect(cl.reload.title).to eql("Updated title")
        end
        it "displays the new information" do
          expect(page).to have_content('Updated title')
        end
        it "redirects to the claim view page" do
          expect(current_path).to eql(claim_path(cl))
        end
      end

      describe "deleting claims" do
        before { click_link 'Delete' }

        it "deletes the claim" do
          expect(Claim.find_by_id(cl.id)).to be_nil
        end
        it "redirects to the claims index page" do
          expect(current_path).to eql(claims_path)
        end
        it "no longer displays info about the claim" do
          expect(page).not_to have_content(cl.title)
        end
      end

    end

    describe "comments" do
      let!(:cl) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2)}
      let!(:com) { FactoryGirl.create(:comment, user: user1, claim: cl) }
      before { visit claim_path(cl) }

      describe "viewing comments" do
        let!(:com2) { FactoryGirl.create(:comment, user: user2, claim: cl) }
        before { visit claim_path(cl) }
        it "shows all comments for the claim" do
          expect(page).to have_content(com.content)
          expect(page).to have_content(com2.content)
        end
        it "shows who wrote the comment" do
          expect(page).to have_content(com.user.name)
          expect(page).to have_content(com2.user.name)
        end
        it "only shows edit links for your comments" do
          expect(page).not_to have_link("Edit Comment", href: edit_comment_path(com2))
        end
      end

      describe "creating comments" do
        context "with invalid info" do
          it "does not create a comment" do
            expect { click_button 'Comment' }.not_to change { Comment.count }
          end
          it "renders errors" do
            click_button 'Comment'
            expect(page).to have_content("can't be blank")
          end
        end

        context "with valid info" do
          before { fill_in 'comment_content', with: 'hello_from_comment' }
          it "creates a comment" do
            before_count = Comment.count
            click_button 'Comment'
            expect(before_count).to eql(Comment.count-1)
          end
          it "displays the comment" do
            click_button 'Comment'
            expect(page).to have_content('hello_from_comment')
          end
        end
      end

      describe "editing comments" do
        before { click_link 'Edit Comment' }

        context "with invalid info" do
          before do
            fill_in 'comment_content', with: ''
            click_button 'Save changes'
          end
          it "does not save the changes" do
            expect(com.reload.content).not_to eql('')
          end
          it "renders errors" do
            expect(page).to have_content("can't be blank")
          end
        end

        context "with valid info" do
          before do
            fill_in 'comment_content', with: 'Updated content'
            click_button 'Save changes'
          end
          it "saves the changes" do
            expect(com.reload.content).to eql('Updated content')
          end
          it "redirects to the claim page" do
            expect(current_path).to eql(claim_path(cl))
          end
          it "displays the new comment info" do
            expect(page).to have_content("Updated content")
          end
        end

        describe "Deleting comments" do
          before { click_link 'Delete' }
          it "deletes the comment" do
            expect(Comment.find_by_id(com.id)).to be_nil
          end
          it "returns to the claim page" do
            expect(current_path).to eql(claim_path(cl))
          end
        end

      end
    end

  end

end
