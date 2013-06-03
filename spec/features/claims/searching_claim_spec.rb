require 'spec_helper'

describe "searching claims" do

  extend ClaimsHarness
  create_factories_and_sign_in

  before { visit claims_path }

  let!(:cl3) { FactoryGirl.create(:claim, user_owed_to: user1,
                user_who_owes: user2, paid: true)}
  let!(:unrelated_cl) { FactoryGirl.create(:claim, user_owed_to: user2,
                  user_who_owes: user3) }

  context "searching by title or description" do
    let!(:cl_title) { FactoryGirl.create(:claim, user_owed_to: user1,
                      user_who_owes: user2, title: 'match')}
    let!(:cl_desc) { FactoryGirl.create(:claim, user_who_owes: user1,
                      user_owed_to: user2, description: 'match')}
    let!(:unrelated_cl) { FactoryGirl.create(:claim, user_owed_to: user2,
                    user_who_owes: user3) }
    before do
      fill_in 'z_title_or_description_cont', with: 'match'
      click_button 'Search Claims'
    end

    it "only returns results which match the string" do
      expect(page).to have_content(cl_title.title)
      expect(page).to have_content(cl_desc.title)
      expect(page).not_to have_content(cl3.title)
    end
    it "does not return claims between your other roommates" do
      expect(page).not_to have_content(unrelated_cl.title)
    end
  end

  context "searching by amount" do
    let!(:cl_amount) { FactoryGirl.create(:claim, user_owed_to: user1,
                      user_who_owes: user2, amount: 3)}

    context "less than" do
      before do
        fill_in 'z_amount_max', with: 5
        click_button 'Search Claims'
      end
      it "only returns results which match the amounts" do
        expect(page).to have_content(cl_amount.title)
        expect(page).not_to have_content(cl.title)
      end
      it "does not show claims between your other roommates" do
        expect(page).not_to have_content(unrelated_cl.title)
      end
    end

    context "greater than" do
      let!(:cl_amount) { FactoryGirl.create(:claim, user_owed_to: user1,
                      user_who_owes: user2, amount: 45)}
      before do
        fill_in 'z_amount_min', with: 44
        click_button 'Search Claims'
      end
      it "only returns results which match the amounts" do
        expect(page).to have_content(cl_amount.title)
        expect(page).not_to have_content(cl.title)
      end
      it "does not show claims between your other roommates" do
        expect(page).not_to have_content(unrelated_cl.title)
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
     it "does not show claims between your other roommates" do
        expect(page).not_to have_content(unrelated_cl.title)
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
        expect(page).not_to have_content(unrelated_cl.title)
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
        expect(page).not_to have_content(unrelated_cl.title)
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
          expect(page).not_to have_content(unrelated_cl.title)
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
          expect(page).not_to have_content(unrelated_cl.title)
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
        expect(page).not_to have_content(unrelated_cl.title)
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
        expect(page).not_to have_content(unrelated_cl.title)
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
        expect(page).not_to have_content(unrelated_cl.title)
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
          expect(page).not_to have_content(unrelated_cl.title)
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
        end
        it "does not show claims between your other roommates" do
          expect(page).not_to have_content(unrelated_cl.title)
        end
      end
    end

  end

  context "combining fields" do

    context "searching for debts you are owed from a particular user" do
      let!(:cl4) {  FactoryGirl.create(:claim, user_owed_to: user1,
                user_who_owes: user3)}

      before do
        check 'To receive'
        check "#{user3.name}-checkbox"
        click_button 'Search Claims'
      end
      it "displays only claims which match all queries" do
        expect(page).to have_content(cl4.title)
        expect(page).not_to have_content(cl3.title, cl2.title, cl.title)
      end
    end

    context "searching for claims that you owe multiple users" do
      let!(:you_owe_user2) { FactoryGirl.create(:claim, user_owed_to: user2,
                user_who_owes: user1) }
      let!(:you_owe_user3) { FactoryGirl.create(:claim, user_owed_to: user3,
                user_who_owes: user1) }
      before do
        check 'To pay'
        check "#{user2.name}-checkbox"
        check "#{user3.name}-checkbox"
        click_button 'Search Claims'
      end

      it "displays only claims which match all queries" do
        expect(page).to have_content(you_owe_user2.title, you_owe_user3.title, cl2.title)
        expect(page).not_to have_content(cl3.title, cl.title)
      end

    end
  end

end
