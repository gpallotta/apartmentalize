require 'spec_helper'

describe Claim do

  let(:group) { FactoryGirl.create(:group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let(:cl1) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user1) }
  let!(:cl2) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user1) }
  let!(:cl3) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user1) }

  describe "associations" do

    context "user_owed_to" do
      it { should validate_presence_of(:user_owed_to)}
      it { should belong_to(:user_owed_to) }
      it "sets the user_owed_to" do
        expect(cl1.user_owed_to).to eql(user1)
      end
    end

    context "user_who_owes" do
      it { should validate_presence_of(:user_who_owes)}
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

    describe ".most_recent_first" do
      it "returns newer claims first" do
        expect(Claim.most_recent_first.first).to eql(cl3)
        expect(Claim.most_recent_first.second).to eql(cl2)
      end
    end
  end


  describe "properties" do

    context "title" do
      it { should respond_to(:title) }
      it { should validate_presence_of(:title) }
    end

    context "paid" do
      it { should respond_to(:paid) }
      it { should_not be_paid }
    end

    context "description" do
      it { should respond_to(:description) }
      it { should_not validate_presence_of(:description) }
      it { should ensure_length_of(:description).is_at_most(200) }
    end

    context "amount" do
      it { should respond_to(:amount) }
      it { should validate_presence_of(:amount) }
      it { should allow_value(1.23, 1, 1.1).for(:amount) }
      it { should_not allow_value(1.234, -1, 0, 'hello').for(:amount) }
    end

    context "paid on" do
      it { should respond_to(:paid_on) }
    end

  end

  describe "methods" do
    context ".mark_as_paid" do
      before { cl1.mark_as_paid }
      it "marks the debt as paid" do
        expect(cl1).to be_paid
      end
      it "sets the paid_on property to the current time" do
        expect(cl1.paid_on).to be_a(Time)
      end
    end
  end

end
