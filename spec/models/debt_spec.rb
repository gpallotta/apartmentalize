# == Schema Information
#
# Table name: debts
#
#  id               :integer          not null, primary key
#  title            :string(255)      not null
#  description      :string(200)
#  amount           :decimal(10, 2)   not null
#  paid             :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_owed_to_id  :integer          not null
#  user_who_owes_id :integer          not null
#

require 'spec_helper'

describe Debt do

  let(:group) { FactoryGirl.create(:group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let(:d1) { FactoryGirl.create(:debt, user_owed_to: user1, user_who_owes: user1) }
  let!(:d2) { FactoryGirl.create(:debt, user_owed_to: user1, user_who_owes: user1) }
  let!(:d3) { FactoryGirl.create(:debt, user_owed_to: user1, user_who_owes: user1) }

  describe "associations" do

    context "user_owed_to" do
      it { should validate_presence_of(:user_owed_to)}
      it { should belong_to(:user_owed_to) }
      it "sets the user_owed_to" do
        expect(d1.user_owed_to).to eql(user1)
      end
    end

    context "user_who_owes" do
      it { should validate_presence_of(:user_who_owes)}
      it { should belong_to(:user_who_owes) }
      it "sets the user_who_owes" do
        expect(d1.user_who_owes).to eql(user1)
      end
    end

    context "comments" do
      let!(:c1) { FactoryGirl.create(:comment, user: user1, debt: d1)}
      let!(:c2) { FactoryGirl.create(:comment, user: user1, debt: d2)}

      it { should have_many(:comments).dependent(:destroy) }
      it "returns comments which are its own" do
        expect(d1.comments).to include(c1)
        expect(d1.comments).not_to include(c2)
      end

    end

  end # end for associations

  describe "scope" do

    context "paid status" do
      before { d1.update_attributes(paid: true) }

      context ".unpaid" do
        it "returns only unpaid debts" do
          expect(Debt.unpaid).to include(d2, d3)
          expect(Debt.unpaid).not_to include(d1)
        end
      end

      context ".paid" do
        it "returns only paid debts" do
          expect(Debt.paid).to include(d1)
          expect(Debt.paid).not_to include(d2, d3)
        end
      end
    end # end for paid status

    describe ".most_recent_first" do
      it "returns newer debts first" do
        expect(Debt.most_recent_first.first).to eql(d3)
        expect(Debt.most_recent_first.second).to eql(d2)
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

  end

end
