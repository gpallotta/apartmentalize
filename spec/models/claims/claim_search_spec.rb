require 'spec_helper'

describe ClaimSearch do

  extend ClaimsHarness
  let!(:group) { FactoryGirl.create(:group) }
  let!(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:user3) { FactoryGirl.create(:user, group: group) }
  let!(:cl) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2)}
  let!(:cl2) { FactoryGirl.create(:claim, user_owed_to: user2, user_who_owes: user1)}

  let!(:params) do
    params = {}
    params[:z] = {}
    params
  end

  describe "instance vars" do
    let!(:cs) { ClaimSearch.new(user1, Claim.scoped, {}) }
    it "has a user" do
      expect(cs.user).to be_a(User)
    end

    it "has a list of claims" do
      expect(cs.claims.first).to be_a Claim
    end

    it "has a list of params" do
      expect(cs.params).to be_a Hash
    end
  end

  describe ".sort" do

    before { params[:direction] = "asc" }

    context "when sorting by owed_by name" do
      before { params[:sort] = "owed_by" }
      it "sorts by the name of the user owed to" do
        owed_by_sort = ClaimSearch.new(user1, user1.claims, params)
        expect(owed_by_sort.claims.first).to eql(cl2)
      end
    end

    context "when sorting by owed_to name" do
      before do
        params[:sort] = "owed_to"
        params[:direction] = "desc"
      end
      it "sorts by the name of the user owed to" do
        owed_to_sort = ClaimSearch.new(user1, user1.claims, params)
        expect(owed_to_sort.claims.first).to eql(cl2)
      end
    end

    context "when sorting by anything else" do
      let!(:low_amount_cl) { FactoryGirl.create(:claim, user_owed_to: user2,
               user_who_owes: user1, amount: 2) }
      before { params[:sort] = "amount" }

      it "sorts by the passed in params" do
        amount_sort = ClaimSearch.new(user1, user1.claims, params)
        expect(amount_sort.claims.first).to eql(low_amount_cl)
      end
    end

  end

  describe ".owed_user_index" do

    describe "searching for claims you are owed" do
      let!(:cl3) {  FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user3) }
      before { params[:z][:to_receive] = "true" }

      context "when no usernames are checked" do
        it "returns all claims you are owed" do
          owed_search = ClaimSearch.new(user1, user1.claims, params)
          owed_search.owed_user_index
          expect(owed_search.claims).to include(cl, cl3)
          expect(owed_search.claims).not_to include(cl2)
        end
      end

      context "when a username is checked" do
        before { params[:z][:user_name] = [user3.name]}
        it "returns only claims that user owes you" do
          owed_search = ClaimSearch.new(user1, user1.claims, params)
          owed_search.owed_user_index
          expect(owed_search.claims).to include(cl3)
          expect(owed_search.claims).not_to include(cl)
        end
      end
    end

    describe "searching for claims you owe" do
      let!(:cl3) {  FactoryGirl.create(:claim, user_owed_to: user3, user_who_owes: user1) }
      before { params[:z][:to_pay] = "true" }

      context "when no usernames are passed in" do
        it "returns all claims you owe" do
          owes_search = ClaimSearch.new(user1, user1.claims, params)
          owes_search.owed_user_index
          expect(owes_search.claims).to include(cl2, cl3)
        end
      end
      context "when a username is passed in" do
        before { params[:z][:user_name] = [user3.name]}
        it "returns only claims you owe the specific user" do
          owes_search = ClaimSearch.new(user1, user1.claims, params)
          owes_search.owed_user_index
          expect(owes_search.claims).to include(cl3)
          expect(owes_search.claims).not_to include(cl2)
        end
      end
    end

    describe "searching for both claims you owe and are owed" do
      let!(:cl3) {  FactoryGirl.create(:claim, user_owed_to: user3, user_who_owes: user1) }
      let!(:cl4) {  FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user3) }

      before do
        params[:z][:to_pay] = "true"
        params[:z][:to_receive] = "true"
      end

      context "when no usernames are passed in" do
        it "returns all claims you owe and are owed" do
          both_search = ClaimSearch.new(user1, user1.claims, params)
          both_search.owed_user_index
          expect(both_search.claims).to include(cl, cl2, cl3, cl4)
        end
      end
      context "when a username is passed in" do
        before { params[:z][:user_name] = [user3.name] }
        it "returns claims that you owe that user or are owed by that user" do
          both_search = ClaimSearch.new(user1, user1.claims, params)
          both_search.owed_user_index
          expect(both_search.claims).to include(cl3, cl4)
          expect(both_search.claims).not_to include(cl, cl2)
        end
      end
    end
  end

  describe ".amount_between" do

    before { cl.update_attributes(amount: 7) }

    context "when a minimum amount is passed in" do
      let!(:cl3) {  FactoryGirl.create(:claim, user_owed_to: user2,
                      user_who_owes: user1, amount: 10)}
      before { params[:z][:amount_min] = 10}

      it "returns claims with an amount greater than or equal to the min" do
        min_search = ClaimSearch.new(user1, user1.claims, params)
        min_search.amount_between
        expect(min_search.claims).to include(cl2, cl3)
        expect(min_search.claims).not_to include(cl)
      end
    end

    context "when a max amount is passed in" do
      let!(:cl3) {  FactoryGirl.create(:claim, user_owed_to: user2,
                      user_who_owes: user1, amount: 26)}
      before { params[:z][:amount_max] = 25}

      it "returns claims with an amount no greater than the max" do
        max_search = ClaimSearch.new(user1, user1.claims, params)
        max_search.amount_between
        expect(max_search.claims).to include(cl2, cl)
        expect(max_search.claims).not_to include(cl3)
      end
    end

    context "when both a min and max are passed in" do
      before do
        params[:z][:amount_min] = 6
        params[:z][:amount_max] = 8
      end

      it "returns claims with amount between the values" do
        max_search = ClaimSearch.new(user1, user1.claims, params)
        max_search.amount_between
        expect(max_search.claims).to include(cl)
        expect(max_search.claims).not_to include(cl2)
      end
    end

    context "when neither a min nor max is passed in" do
      it "does not filter out any claims" do
        no_search = ClaimSearch.new(user1, user1.claims, params)
        no_search.amount_between
        expect(no_search.claims).to include(cl, cl2)
      end
    end
  end

  describe ".title_or_description_contains" do

    context "when a phrase is passed in" do
      before do
        params[:z][:title_or_description_cont] = 'hello'
        cl.update_attributes(title: 'hello')
      end
        let!(:desc_cl) { FactoryGirl.create(:claim, user_owed_to: user1,
                   user_who_owes: user2, description: 'hello')}


      it "returns only claims whose titles or descriptions match the phrase" do
        phrase_search = ClaimSearch.new(user1, user1.claims, params)
        phrase_search.title_or_description_contains
        expect(phrase_search.claims).to include(cl, desc_cl)
        expect(phrase_search.claims).not_to include(cl2)
      end
    end

    context "when no phrase is passed in" do

      it "should include all claims" do
        no_phrase_search = ClaimSearch.new(user1, user1.claims, params)
        no_phrase_search.title_or_description_contains
        expect(no_phrase_search.claims).to include(cl)
        expect(no_phrase_search.claims).to include(cl2)
      end
    end

  end


  describe ".paid_or_unpaid" do

    before { cl.update_attributes(paid: true) }

    context "including paid claims" do
      before { params[:z][:paid_status] = ["true"] }

      it "returns claims which are paid" do
        paid_cs = ClaimSearch.new(user1, user1.claims, params)
        paid_cs.paid_or_unpaid
        expect(paid_cs.claims).to include(cl)
        expect(paid_cs.claims).not_to include(cl2)
      end
    end

    context "including unpaid claims" do
      before { params[:z][:paid_status] = ["false"] }

      it "returns unpaid claims" do
        unpaid_cs = ClaimSearch.new(user1, user1.claims, params)
        unpaid_cs.paid_or_unpaid
        expect(unpaid_cs.claims).to include(cl2)
        expect(unpaid_cs.claims).not_to include(cl)
      end
    end

    context "including neither" do

      it "should include both paid and unpaid" do
        no_filter = ClaimSearch.new(user1, user1.claims, params)
        no_filter.paid_or_unpaid
        expect(no_filter.claims).to include(cl)
        expect(no_filter.claims).to include(cl2)
      end
    end

    context "including both paid and unpaid" do
      before { params[:paid_status] = ["true", "false"] }

      it "should include both paid and unpaid" do
        both_cs = ClaimSearch.new(user1, user1.claims, params)
        both_cs.paid_or_unpaid
        expect(both_cs.claims).to include(cl)
        expect(both_cs.claims).to include(cl2)
      end
    end
  end

end
