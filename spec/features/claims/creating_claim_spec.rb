###############

# As a user
# I want to create new claim
# so I can keep track of items I am owed for

# AC:
# I can create a claim
# I am notified when a claim is not created due to erroneous entry
# I can create the same claim for all roommates at once
# I can create a claim for only certain roommates at the same time

###############


###############

# As a user
# I want to assign certain information to a claim
# so I can keep track of what I want

# AC:
# I can set who owes the claim
# I can give the claim a title
# I can give the claim a description
# I can give the claim an amount

###############


require 'spec_helper'



describe "creating claims" do

  extend ClaimsHarness
  create_factories_and_sign_in

  before { visit claims_path }

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
        expect(Claim.last.amount).to eql(5)
        expect(page).to have_content('Test')
        expect(page).to have_content(5)
      end
    end

    context "for only some users" do
      before { find(:css, "##{user2.name}").set(false) }
      it "creates the claim for only the checked users" do
        expect { click_button 'Create Claim' }.to change {Claim.count }.by(1)
        expect(Claim.last.amount).to eql(5)
      end
    end
  end

  context "using the autosplit feature" do
    before do
      fill_in 'claim_title', with: 'Split'
      fill_in 'claim_amount', with: 9
      check('Split evenly')
    end
    it "splits up the entered amount evenly between all checked users" do
      before_count = Claim.count
      click_button 'Create Claim'
      results = Claim.find(:all, :order => 'id desc', :limit => 2)
      results.each do |c|
        expect(c.amount).to eql(3)
      end
    end
  end

end

