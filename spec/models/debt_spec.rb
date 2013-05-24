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

  describe "scope" do

    let!(:group) { FactoryGirl.create(:group) }
    let!(:other_group) { FactoryGirl.create(:group) }
    let!(:other_user) { FactoryGirl.create(:user, group: other_group) }
    let!(:user1) { FactoryGirl.create(:user, group: group) }
    let!(:user2) { FactoryGirl.create(:user, group: group) }
    let!(:d1) { FactoryGirl.create(:debt, user_owed_to: user1, user_who_owes: user2) }
    let!(:d2) { FactoryGirl.create(:debt, user_owed_to: user2, user_who_owes: user1) }
    let!(:d3) { FactoryGirl.create(:debt, user_owed_to: other_user, user_who_owes: other_user) }

    context "paid status" do

      before { d1.update_attributes(paid: true) }

      context ".unpaid" do
        it "returns only unpaid debts" do
          expect(user1.debts.unpaid).not_to include(d1, d3)
          expect(user1.debts.unpaid).to include(d2)
        end
      end

      context ".paid" do
        it "returns only paid debts" do
          expect(user1.debts.paid).to include(d1)
          expect(user1.debts.paid).not_to include(d2, d3)
        end
      end
    end

    describe ".most_recent_first" do
      it "returns newer debts first" do
        expect(user1.debts.most_recent_first.first).to eql(d2)
        expect(user1.debts.most_recent_first.second).to eql(d1)
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

  describe "associations" do

    context "user_owed_to" do
      it { should validate_presence_of(:user_owed_to)}
      it { should belong_to(:user_owed_to) }
    end

    context "user_who_owes" do
      it { should validate_presence_of(:user_who_owes)}
      it { should belong_to(:user_who_owes) }
    end

    context "comments" do
      it { should have_many(:comments).dependent(:destroy) }
    end

  end

end
