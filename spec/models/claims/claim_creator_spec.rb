require 'spec_helper'

describe ClaimCreator do
  let!(:group) { FactoryGirl.create(:group)}
  let!(:user1) { FactoryGirl.create(:user, group: group) }
  let!(:user2) { FactoryGirl.create(:user, group: group) }
  let!(:user3) { FactoryGirl.create(:user, group: group) }
  let!(:params) do
      params = {}
      params[:claim] = {}
      params[:claim][:amount] = 5
      params[:claim][:title] = "valid"
      params[:claim][:description] = ""
      params[user2.name] = true
      params[user3.name] = true
      params
    end

  describe "values taken in" do
    let!(:creator) { ClaimCreator.new(user1, params)}
    it "has a user" do
      expect(creator.user).to eql(user1)
    end
    it "has a has of params" do
      expect(creator.params).to eql(params)
    end
  end


  describe "when all saves succeed" do
    let!(:creator) { ClaimCreator.new(user1, params)}
    before { creator.create_claims }

    context "all_valid" do
      it "is true if all saves are successful" do
        expect(creator.all_valid).to be_true
      end
    end

    context "created_claims" do
      it "contains all claims saved successfully" do
        expect(creator.created_claims.first).to be_a(Claim)
        expect(creator.created_claims.length).to eql(2)
      end
    end

  end

  describe "when a save fails" do
    before { params[:claim][:amount] = nil }
    let!(:creator_with_failed_save) { ClaimCreator.new(user1, params)}

    context "all_valid" do
      it "is false if any save fails" do
        creator_with_failed_save.create_claims
        expect(creator_with_failed_save.all_valid).to be_false
      end
    end

    context "created_claims" do
      it "does not contain claims not saved successfully" do
        creator_with_failed_save.create_claims
        expect(creator_with_failed_save.created_claims.length).to eql(0)
      end
    end

  end

  describe "all_valid" do

    let!(:creator) { ClaimCreator.new(user1, params)}

  end

end
