require 'spec_helper'

describe ClaimSearch do

  let!(:group) { FactoryGirl.create(:group) }
  let!(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:user3) { FactoryGirl.create(:user, group: group) }
  let!(:cl) { FactoryGirl.create(:claim, user_owed_to: user1,
          user_who_owes: user2, amount: 5, title: 'greg')}
  let!(:cl2) { FactoryGirl.create(:claim, user_owed_to: user2,
                user_who_owes: user1, description: 'greg')}
  let!(:params) do
    params = { z: {} }
    params[:z][:date_paid_min] = ''
    params[:z][:date_paid_max] = ''
    params[:z][:date_created_min] = ''
    params[:z][:date_created_max] = ''
    params[:z][:title_or_description_cont] = ''
    params[:z][:amount_min] = ''
    params[:z][:amount_max] = ''
    params
  end

  describe "search" do

    context "amount" do
      it "filters by min amount" do
        params[:z][:amount_min] = 24
        cs = ClaimSearch.new(user1, params)
        result = cs.search
        expect(result).to include(cl2)
        expect(result).not_to include(cl)
      end
      it "filters by max amount" do
        params[:z][:amount_max] = 6
        cs = ClaimSearch.new(user1, params)
        result = cs.search
        expect(result).to include(cl)
        expect(result).not_to include(cl2)
      end
    end

    context "title/desc" do
      it "filters by title or desc containing" do
        params[:z][:title_or_description_cont] = 'greg'
        cl3 = FactoryGirl.create(:claim, user_who_owes: user2,
                user_owed_to: user1)
        cs = ClaimSearch.new(user1, params)
        result = cs.search
        expect(result).to include(cl)
        expect(result).to include(cl2)
        expect(result).not_to include(cl3)
      end
    end

    context "paid status" do
      it "filters by paid claims" do
        params[:z][:include_paid] = true
        cl.update_attributes(paid: true)
        cs = ClaimSearch.new(user1, params)
        result = cs.search
        expect(result).to include(cl)
        expect(result).not_to include(cl2)
      end
      it "filters by unpaid claims" do
        params[:z][:include_unpaid] = true
        cl2.update_attributes(paid: true)
        cs = ClaimSearch.new(user1, params)
        result = cs.search
        expect(result).to include(cl)
        expect(result).not_to include(cl2)
      end
    end

    context "date-related searching" do

      before(:each) do
        cl.created_at = 5.days.ago
        cl.paid_on = 5.days.ago
        cl2.created_at = 7.days.ago
        cl2.paid_on = 7.days.ago
        cl.save
        cl2.save
      end

      context "created between" do
        it "filters by max date created" do
          params[:z][:date_created_max] = 6.days.ago.
                  strftime("%m/%d/%Y %H:%M:%S")
          cs = ClaimSearch.new(user1, params)
          result = cs.search
          expect(result).to include(cl2)
          expect(result).not_to include(cl)
        end
        it "filters by min date created" do
         params[:z][:date_created_min] = 6.days.ago.
                  strftime("%m/%d/%Y %H:%M:%S")
          cs = ClaimSearch.new(user1, params)
          result = cs.search
          expect(result).to include(cl)
          expect(result).not_to include(cl2)
        end
      end

      context "paid between" do
        it "filters by max date paid" do
          params[:z][:date_paid_max] = 6.days.ago.
                  strftime("%m/%d/%Y %H:%M:%S")
          cs = ClaimSearch.new(user1, params)
          result = cs.search
          expect(result).to include(cl2)
          expect(result).not_to include(cl)
        end
        it "filters by min date paid" do
         params[:z][:date_paid_min] = 6.days.ago.
                  strftime("%m/%d/%Y %H:%M:%S")
          cs = ClaimSearch.new(user1, params)
          result = cs.search
          expect(result).to include(cl)
          expect(result).not_to include(cl2)
        end
      end

    end

    context "by user" do
      let!(:cl3) { FactoryGirl.create(:claim, user_who_owes: user3,
                  user_owed_to: user1) }
      it "filters by claims related to a user" do
        params[:z][:user_id] = [user3.id]
        cs = ClaimSearch.new(user1, params)
        result = cs.search
        expect(result).to include(cl3)
        expect(result).not_to include(cl)
      end
    end

    context "by who owes the claim" do
      it "filters by claims you owe" do
        params[:z][:to_pay] = true
        cs = ClaimSearch.new(user1, params)
        result = cs.search
        expect(result).to include(cl2)
        expect(result).not_to include(cl)
      end
      it "filters by claims you are owed" do
        params[:z][:to_receive] = true
        cs = ClaimSearch.new(user1, params)
        result = cs.search
        expect(result).to include(cl)
        expect(result).not_to include(cl2)
      end
    end

  end

end
