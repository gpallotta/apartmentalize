require 'spec_helper'

describe Comment do

  let(:group) { FactoryGirl.create(:group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let(:cl1) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user1) }
  let(:cl2) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user1) }
  let!(:c1) { FactoryGirl.create(:comment, claim: cl1, user: user1) }
  let!(:c2) { FactoryGirl.create(:comment, claim: cl2, user: user1) }

  describe "scope" do

    context ".oldest_first" do
      it "Returns oldest comment first" do
        expect(Comment.oldest_first.first).to eql(c1)
        expect(Comment.oldest_first.second).to eql(c2)
      end
    end
  end

  describe "associations" do

    context "claim" do
      it { should respond_to(:claim) }
      it { should belong_to(:claim) }
      it { should validate_presence_of(:claim) }
      it "returns the correct claim" do
        expect(c1.claim).to eql(cl1)
      end
    end

    context "user" do
      it { should respond_to(:user) }
      it { should belong_to(:user) }
      it { should validate_presence_of(:user) }
      it "returns the correct user" do
        expect(c1.user).to eql(user1)
      end
    end
  end

  describe "properties" do

    context "content" do
      it { should respond_to(:content) }
      it { should validate_presence_of(:content) }
    end

  end

end
