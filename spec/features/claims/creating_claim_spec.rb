###############

# As a user
# I want to create new debts
# so I can keep track of items I am owed for

# AC:
# I can create a debt
# I am notified when a debt is not created due to erroneous entry
# I can create the same debt for all roommates at once
# I can create a debt for only certain roommates at the same time

###############


###############

# As a user
# I want to assign certain information to a debt
# so I can keep track of what I want

# AC:
# I can set who owes the debt
# I can give the debt a title
# I can give the debt a description
# I can give the debt an amount

###############


require 'spec_helper'

describe "claim pages" do

  extend ClaimsHarness
  create_factories_and_sign_in

  before { visit claims_path }

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
          expect(page).to have_content('Test')
          expect(page).to have_content(5)
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
