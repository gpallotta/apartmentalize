require 'spec_helper'

describe Comment do

  let(:group) { FactoryGirl.create(:group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let(:d1) { FactoryGirl.create(:debt, user_owed_to: user1, user_who_owes: user1) }
  let(:d2) { FactoryGirl.create(:debt, user_owed_to: user1, user_who_owes: user1) }
  let!(:c1) { FactoryGirl.create(:comment, debt: d1, user: user1) }
  let!(:c2) { FactoryGirl.create(:comment, debt: d2, user: user1) }

  describe "scope" do
    context ".most_recent_first" do
      it "returns newest comment first" do
        expect(Comment.most_recent_first.first).to eql(c2)
        expect(Comment.most_recent_first.second).to eql(c1)
      end
    end
  end

  describe "associations" do

    context "debt" do

      it { should respond_to(:debt) }
      it { should belong_to(:debt) }
      it { should validate_presence_of(:debt) }
      it "returns the correct debt" do
        expect(c1.debt).to eql(d1)
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
