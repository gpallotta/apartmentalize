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

    let!(:cl2) { FactoryGirl.create(:claim, user_owed_to: user2,
                   user_who_owes: user1, amount: 3)}
    let!(:cl3) { FactoryGirl.create(:claim, user_owed_to: user1,
                    user_who_owes: user2, paid: true)}
    let!(:roommate_cl) { FactoryGirl.create(:claim, user_owed_to: user2,
                    user_who_owes: user3) }

    describe "viewing totals" do

      let(:total) { cl.amount + cl3.amount - cl2.amount }
      before { visit claims_path }

      it "displays the effective balance" do
        expect(page).to have_content(total)
      end

      it "displays the total for each user" do
        expect(page).to have_content("#{user2.name} #{total}")
      end

    end

    describe "viewing claims" do

      before { visit claims_path }

      context "claims within your group" do
        it "displays all claims related to you by default" do
          expect(page).to have_content(cl.title)
          expect(page).to have_content(cl2.title)
          expect(page).to have_content(cl3.title)
        end
        it "does not display claims that are between others in your group" do
          expect(page).not_to have_content(roommate_cl.title)
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
        it "has a link to mark debts you are owed as paid" do
          expect(page).to have_link('Mark paid', href: mark_as_paid_claim_path(cl))
        end
        it "does not have a link to mark debts you owe as paid" do
          expect(page).not_to have_link('Mark paid', href: mark_as_paid_claim_path(cl2))
        end
      end

      context "claims from other groups" do
        let(:other_group) { FactoryGirl.create(:group) }
        let(:other_user) { FactoryGirl.create(:user, group: group) }
        let!(:other_claim) { FactoryGirl.create(:claim, user_owed_to: other_user,
                              user_owed_to: other_user)}
        it "does not show claims from other groups" do
          visit claims_path
          expect(page).not_to have_content(other_claim.title)
        end
      end
    end

    describe "searching claims" do
      let!(:cl3) { FactoryGirl.create(:claim, user_owed_to: user1,
                    user_who_owes: user2, paid: true)}

      context "searching by title or description" do
        let!(:cl_title) { FactoryGirl.create(:claim, user_owed_to: user1,
                          user_who_owes: user2, title: 'match')}
        let!(:cl_desc) { FactoryGirl.create(:claim, user_who_owes: user1,
                          user_owed_to: user2, description: 'match')}
        before do
          fill_in 'q_title_or_description_cont', with: 'match'
          click_button 'Search Claims'
        end

        it "only returns results which match the string" do
          expect(page).to have_content(cl_title.title)
          expect(page).to have_content(cl_title.title)
          expect(page).not_to have_content(cl3.title)
        end
        it "does not return claims between your other roommates" do
          expect(page).not_to have_content(roommate_cl.title)
        end
      end

      context "searching by amount" do
        let!(:cl_amount) { FactoryGirl.create(:claim, user_owed_to: user1,
                          user_who_owes: user2, amount: 3)}

        context "less than" do
          before do
            fill_in 'q_amount_lteq', with: 5
            click_button 'Search Claims'
          end
          it "only returns results which match the amounts" do
            expect(page).to have_content(cl_amount.title)
          end
          it "does not show claims between your other roommates" do
            expect(page).not_to have_content(roommate_cl.title)
          end
        end

        context "greater than" do
          let!(:cl_amount) { FactoryGirl.create(:claim, user_owed_to: user1,
                          user_who_owes: user2, amount: 45)}
          before do
            fill_in 'q_amount_gteq', with: 44
            click_button 'Search Claims'
          end
          it "only returns results which match the amounts" do
            expect(page).to have_content(cl_amount.title)
          end
          it "does not show claims between your other roommates" do
            expect(page).not_to have_content(roommate_cl.title)
          end
        end
      end

      context "paid status" do

        context "including paid claims" do
          before do
            check('paid-checkbox')
            click_button 'Search Claims'
          end
          it "includes only paid claims in the results" do
            expect(page).to have_content(cl3.title)
            expect(page).not_to have_content(cl.title)
          end
          it "does not show a mark as paid link for paid claims" do
            expect(page).not_to have_link('Mark paid',
                          href: mark_as_paid_claim_path(cl3))
          end
         it "does not show claims between your other roommates" do
            expect(page).not_to have_content(roommate_cl.title)
          end
        end

        context "including unpaid claims" do
          before do
            check('unpaid-checkbox')
            click_button 'Search Claims'
          end
          it "includes only unpaid claims in the results" do
            expect(page).to have_content(cl.title)
            expect(page).not_to have_content(cl3.title)
          end
          it "does not show claims between your other roommates" do
            expect(page).not_to have_content(roommate_cl.title)
          end
        end

        context "including both" do
          before do
            check('paid-checkbox')
            check('unpaid-checkbox')
            click_button 'Search Claims'
          end
          it "includes both paid and unpaid claims in the results" do
            expect(page).to have_content(cl.title)
            expect(page).to have_content(cl3.title)
          end
         it "does not show claims between your other roommates" do
            expect(page).not_to have_content(roommate_cl.title)
          end
        end

      end # end for paid status

      context "by user" do
        let!(:cl4) { FactoryGirl.create(:claim, user_owed_to: user1,
                      user_who_owes: user3)}
        before { visit claims_path }

        context "all other users" do
          context "when all are checked" do
            before do
              check("#{user2.name}-checkbox")
              check("#{user3.name}-checkbox")
              click_button 'Search Claims'
            end
            it "displays claims for all users and you" do
              expect(page).to have_content(cl.title)
              expect(page).to have_content(cl2.title)
              expect(page).to have_content(cl3.title)
              expect(page).to have_content(cl4.title)
            end
            it "does not show claims between your other roommates" do
              expect(page).not_to have_content(roommate_cl.title)
            end
          end

          context "when none are checked" do
            before do
              click_button 'Search Claims'
            end
            it "displays claims for all users" do
              expect(page).to have_content(cl.title)
              expect(page).to have_content(cl2.title)
              expect(page).to have_content(cl3.title)
              expect(page).to have_content(cl4.title)
            end
            it "does not show claims between your other roommates" do
              expect(page).not_to have_content(roommate_cl.title)
            end
          end
        end

        context "selecting a single user" do
          before do
            check("#{user3.name}-checkbox")
            click_button 'Search Claims'
          end
          it "displays only claims for that user" do
            expect(page).to have_content(cl4.title)
            expect(page).not_to have_content(cl2.title)
            expect(page).not_to have_content(cl3.title)
          end
          it "does not show claims between your other roommates" do
            expect(page).not_to have_content(roommate_cl.title)
          end
        end

      end

      context "by to receive or to pay" do
        let!(:cl4) { FactoryGirl.create(:claim, user_owed_to: user1,
                      user_who_owes: user3)}
        before { visit claims_path }
        context "claims you are owed" do
          before do
            check('To receive')
          end

          it "displays only claims you are to receive" do
            click_button 'Search Claims'
            expect(page).to have_content(cl.title)
            expect(page).to have_content(cl3.title)
            expect(page).not_to have_content(cl2.title)
          end
          it "does not show claims between your other roommates" do
            expect(page).not_to have_content(roommate_cl.title)
          end
        end

        context "claims you owe" do
          before do
            check('To pay')
          end
          it "displays only claims you are to pay" do
            click_button 'Search Claims'
            expect(page).not_to have_content(cl.title)
            expect(page).not_to have_content(cl3.title)
            expect(page).to have_content(cl2.title)
          end
          it "does not show claims between your other roommates" do
            expect(page).not_to have_content(roommate_cl.title)
          end
        end

        context "both claims you owe and are owed" do
          context "when both are unchecked" do
            before do
              check('To pay')
            end
            it "displays both claims you owe and are owed" do
              expect(page).to have_content(cl.title)
              expect(page).to have_content(cl3.title)
              expect(page).to have_content(cl2.title)
            end
            it "does not show claims between your other roommates" do
              expect(page).not_to have_content(roommate_cl.title)
            end
          end

          context "when both are checked" do
            before do
              check('To pay')
              check('To receive')
              click_button 'Search Claims'
            end
            it "displays both claims you owe and are owed" do
              expect(page).to have_content(cl.title)
              expect(page).to have_content(cl3.title)
              expect(page).to have_content(cl2.title)
              save_and_open_page
            end
            it "does not show claims between your other roommates" do
              expect(page).not_to have_content(roommate_cl.title)
            end
          end
        end


      end

    end # end for searching claims

    describe "sorting claims" do

      before { visit claims_path }

      context "by owed_to" do

        before { click_link 'Owed to' }

        it "sorts by descending order" do
          expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
        end
        it "sorts by acesnding if clicked again" do
          click_link 'Owed to'
          expect(page.body.index(cl2.title)).to be > page.body.index(cl.title)
        end
      end

      context "by owed_by" do
        before { click_link 'Owed by' }

        it "sorts by descending order" do
          expect(page.body.index(cl.title)).to be < page.body.index(cl2.title)
        end
        it "sorts by ascending if clicked again" do
          click_link 'Owed by'
          expect(page.body.index(cl.title)).to be > page.body.index(cl2.title)
        end

      end

      context "by title" do
        before { click_link 'Title' }

        it "sorts by descending order" do
          expect(page.body.index(cl.title)).to be < page.body.index(cl2.title)
        end
        it "sorts by ascending if clicked again" do
          click_link 'Title'
          expect(page.body.index(cl.title)).to be > page.body.index(cl2.title)
        end
      end

      context "by amount" do
        before { click_link 'Amount' }

        it "sorts by descending order" do
          expect(page.body.index(cl2.title)).to be < page.body.index(cl.title)
        end
        it "sorts by ascending if clicked again" do
          click_link 'Amount'
          expect(page.body.index(cl2.title)).to be > page.body.index(cl.title)
        end
      end

      context "by created on" do
        let!(:old_claim) { FactoryGirl.create(:claim, user_owed_to: user1,
                        user_who_owes: user2, created_at: 1.day.ago,
                        title: 'old title') }
        before do
          click_link 'Created on'
        end

        it "sorts by descending order" do
          expect(page.body.index(old_claim.title)).to be < page.body.index(cl.title)
        end
        it "sorts by ascending if clicked again" do
          click_link 'Created on'
          expect(page.body.index(old_claim.title)).to be > page.body.index(cl.title)
        end
      end
    end

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
          before { find(:css, "##{user2.name}").set(false) }
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
