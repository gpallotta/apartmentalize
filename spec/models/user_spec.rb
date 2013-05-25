require 'spec_helper'

describe User do

  let(:group) { FactoryGirl.create(:group) }
  let(:other_group) { FactoryGirl.create(:group) }
  let(:other_user) { FactoryGirl.create(:user, group: other_group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let(:user2) { FactoryGirl.create(:user, group: group) }
  let(:d1) { FactoryGirl.create(:debt, user_owed_to: user1, user_who_owes: user2) }
  let(:d2) { FactoryGirl.create(:debt, user_owed_to: user2, user_who_owes: user1) }
  let(:d3) { FactoryGirl.create(:debt, user_owed_to: other_user, user_who_owes: other_user) }

  describe "scope" do

    context ".debts" do
      it { should respond_to(:debts) }
      it "returns all debts for user" do
        expect(user1.debts).to include(d1, d2)
        expect(user1.debts).not_to include(d3)
      end
    end

    context '.debts_owed_to' do
      it "returns debts that are owed to you" do
        expect(user1.debts_owed_to).to include(d1)
        expect(user1.debts_owed_to).not_to include(d2, d3)
      end
    end

    context ".debts_they_owe" do
      it "returns debts that you owe to other users" do
        expect(user1.debts_they_owe).to include(d2)
        expect(user1.debts_they_owe).not_to include(d1, d3)
      end
    end

  end

  describe "associations" do

    context "debts" do

      context "debts_owed_to" do
        it { should have_many(:debts_owed_to).dependent(:destroy) }
        it "returns only debts owed to the user" do
          expect(user1.debts_owed_to).to include(d1)
          expect(user1.debts_owed_to).not_to include(d2, d3)
        end
      end

      context "debts_they_owe" do
        it { should have_many(:debts_they_owe).dependent(:destroy) }
        it "returns only debts that the user owes" do
          expect(user1.debts_they_owe).to include(d2)
          expect(user1.debts_they_owe).not_to include(d1, d3)
        end
      end

    end

    context "chores" do
      let(:c1) { FactoryGirl.create(:chore, user: user1)}
      let(:c2) { FactoryGirl.create(:chore, user: user2)}
      it { should have_many(:chores) }
      it "returns chores which belong to the user" do
        expect(user1.chores).to include(c1)
        expect(user1.chores).not_to include(c2)
      end
    end

    context "group" do
      it { should belong_to(:group) }
      it { should validate_presence_of(:group) }
      it "returns the proper group" do
        expect(user1.group).to eql(group)
      end
    end

    context "comments" do
      let(:com1) { FactoryGirl.create(:comment, debt: d1, user: user1) }
      let(:com2) { FactoryGirl.create(:comment, debt: d1, user: user2) }
      it { should have_many(:comments) }
      it "returns comments which belong to the user" do
        expect(user1.comments).to include(com1)
        expect(user1.comments).not_to include(com2)
      end
    end

  end

  describe "properties" do

    context "name" do
      it { should respond_to(:name) }
      it { should validate_presence_of(:name) }
    end

    context "email" do

      it { should respond_to(:email) }
      it { should validate_presence_of(:email)}
      it { should allow_value('greg@greg.com').for(:email) }
      it { should_not allow_value('greg@@greg.cpm').for(:email) }

      it "validates uniqueness of email" do
        User.new(name: 'Greg', email: 'greg@greg.com', password: '12345678',
                  password_confirmation: '12345678',
                  group: Group.new(identifier: '1')).save!
        should validate_uniqueness_of(:email)
      end # without creation, null constraint on name is violated
    end

    context "password" do
      it { should respond_to(:encrypted_password) }
      it { should respond_to(:password)}
      it { should respond_to(:password_confirmation)}

      it { should validate_presence_of(:password) }
      it { should validate_confirmation_of(:password) }
      it { should ensure_length_of(:password).is_at_least(8) }
    end

  end

end
