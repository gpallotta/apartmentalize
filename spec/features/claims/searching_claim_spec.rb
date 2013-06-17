######################

# As a user
# I want to be able to search through debts
# so I can look for specific information

# AC:
# I can search on debt title
# I can search on debt amount
# I can search on debt paid status
# I can search on roommates
# I can combine search filters

######################


require 'spec_helper'

describe "searching claims" do

  extend ClaimsHarness
  create_factories_and_sign_in

  before { visit claims_path }

  let!(:cl3) { FactoryGirl.create(:claim, user_owed_to: user1,
                user_who_owes: user2, paid: true)}
  let!(:unrelated_cl) { FactoryGirl.create(:claim, user_owed_to: user2,
                  user_who_owes: user3) }

  describe "persisting searches between requests" do
    before do
      fill_in 'z_title_or_description_cont', with: 'match'
      fill_in 'z_amount_min', with: 1
      fill_in 'z_amount_max', with: 2
      check("#{user3.name}-checkbox")
      check("paid-checkbox")
      check("unpaid-checkbox")
      check("To receive")
      check("To pay")
      click_button 'Search Claims'
      click_button 'Search Claims'
    end
    it "maintains form selections after search is performed" do
      expect( find_field('z_title_or_description_cont').value).to eql 'match'
      expect( find_field('z_amount_min').value).to eql '1'
      expect( find_field('z_amount_max').value).to eql '2'
      expect( find("##{user3.name}-checkbox") ).to be_checked
      expect( find("#paid-checkbox") ).to be_checked
      expect( find("#unpaid-checkbox") ).to be_checked
      expect( find("#to-receive") ).to be_checked
      expect( find("#to-pay") ).to be_checked
    end
  end

  describe "persisting search when sorting is changed" do
    let!(:search_cl_1) { FactoryGirl.create(:claim, user_owed_to: user1,
                  user_who_owes: user2, amount: 2) }
    let!(:search_cl_2) { FactoryGirl.create(:claim, user_owed_to: user1,
                  user_who_owes: user2, amount: 1) }
    before do
      visit claims_path
      fill_in 'z_amount_max', with: 3
      click_button 'Search Claims'
    end

    it "does not reset the search when a sort link is clicked" do
      click_link 'Amount'
      expect(page).not_to have_content(cl.title)
      expect(page).not_to have_content(cl2.title)
      expect(page.body.index(search_cl_2.title)).to be < page.body.index(search_cl_1.title)
    end

  end

  describe "resetting the search" do
    before do
      fill_in 'z_title_or_description_cont', with: 'sfsdsdfl'
      click_button 'Search Claims'
      click_link 'Clear'
    end
    it "resets the search to the default" do
      expect(page).to have_content(cl.title)
      expect(page).to have_content(cl2.title)
    end
  end

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
      expect_unrelated_claims_to_not_be_shown
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
        expect_unrelated_claims_to_not_be_shown
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
        expect_unrelated_claims_to_not_be_shown
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
        expect_unrelated_claims_to_not_be_shown
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
        expect_unrelated_claims_to_not_be_shown
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
        expect_unrelated_claims_to_not_be_shown
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
          expect_unrelated_claims_to_not_be_shown
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
          expect_unrelated_claims_to_not_be_shown
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
        expect_unrelated_claims_to_not_be_shown
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
        expect_unrelated_claims_to_not_be_shown
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
        expect_unrelated_claims_to_not_be_shown
      end
    end

    context "both claims you owe and are owed" do
      context "when both are unchecked" do
        it "displays both claims you owe and are owed" do
          click_button 'Search Claims'
          expect(page).to have_content(cl.title)
          expect(page).to have_content(cl2.title)
          expect(page).to have_content(cl3.title)
          expect_unrelated_claims_to_not_be_shown
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
          expect_unrelated_claims_to_not_be_shown
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

  def expect_unrelated_claims_to_not_be_shown
    expect(page).not_to have_content(unrelated_cl.title)
  end

end
