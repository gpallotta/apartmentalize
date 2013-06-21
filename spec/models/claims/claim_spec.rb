require 'spec_helper'

describe Claim do

  let(:group) { FactoryGirl.create(:group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let(:cl1) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user1) }
  let!(:cl2) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user1) }
  let!(:cl3) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user1) }

  describe "associations" do

    context "user_owed_to" do
      it { should have_valid(:user_owed_to).when(User.new) }
      it { should_not have_valid(:user_owed_to).when(nil) }
      it { should belong_to(:user_owed_to) }
      it "sets the user_owed_to" do
        expect(cl1.user_owed_to).to eql(user1)
      end
    end

    context "user_who_owes" do
      it { should have_valid(:user_who_owes).when(User.new) }
      it { should_not have_valid(:user_who_owes).when(nil) }
      it { should belong_to(:user_who_owes) }
      it "sets the user_who_owes" do
        expect(cl1.user_who_owes).to eql(user1)
      end
    end

    context "comments" do
      let!(:c1) { FactoryGirl.create(:comment, user: user1, claim: cl1)}
      let!(:c2) { FactoryGirl.create(:comment, user: user1, claim: cl2)}

      it { should have_many(:comments).dependent(:destroy) }
      it "returns comments which are its own" do
        expect(cl1.comments).to include(c1)
        expect(cl1.comments).not_to include(c2)
      end

    end

  end # end for associations

  describe "scope" do

    context "paid status" do
      before { cl1.update_attributes(paid: true) }

      context ".unpaid" do
        it "returns only unpaid claims" do
          expect(Claim.unpaid).to include(cl2, cl3)
          expect(Claim.unpaid).not_to include(cl1)
        end
      end

      context ".paid" do
        it "returns only paid claims" do
          expect(Claim.paid).to include(cl1)
          expect(Claim.paid).not_to include(cl2, cl3)
        end
      end
    end # end for paid status

  end


  describe "properties" do

    context "title" do
      it { should respond_to(:title) }
      it { should_not have_valid(:title).when(nil, '') }
      it { should have_valid(:title).when('string') }
    end

    context "paid" do
      it { should respond_to(:paid) }
      it { should_not be_paid }
    end

    context "description" do
      it { should respond_to(:description) }
      it { should ensure_length_of(:description).is_at_most(200) }
    end

    context "amount" do
      it { should respond_to(:amount) }
      it { should have_valid(:amount).when(1.23, 1, 1.1) }
      it { should_not have_valid(:amount).when(1.234, -1, 0, 'hello') }
    end

    context "paid on" do
      it { should respond_to(:paid_on) }
    end

  end

  describe "methods" do
    describe ".mark_as_paid" do
      before { cl1.mark_as_paid }
      it "marks the debt as paid" do
        expect(cl1).to be_paid
      end
      it "sets the paid_on property to the current time" do
        expect(cl1.paid_on).to be_a(Time)
      end
    end

    describe ".involves?" do
      it "returns true if the user owes or is owed" do
        expect(cl1.involves?(user1)).to be_true
      end
      it "returns false if the user is unrelated" do
        user2 = FactoryGirl.create(:user)
        expect(cl1.involves?(user2)).to be_false
      end
    end
  end

end
