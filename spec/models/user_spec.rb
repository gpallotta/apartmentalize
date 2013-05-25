require 'spec_helper'

describe User do

  let(:group) { FactoryGirl.create(:group) }
  let(:other_group) { FactoryGirl.create(:group) }
  let(:other_user) { FactoryGirl.create(:user, group: other_group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let(:user2) { FactoryGirl.create(:user, group: group) }
  let(:c1) { FactoryGirl.create(:claim, user_owed_to: user1, user_who_owes: user2) }
  let(:c2) { FactoryGirl.create(:claim, user_owed_to: user2, user_who_owes: user1) }
  let(:c3) { FactoryGirl.create(:claim, user_owed_to: other_user, user_who_owes: other_user) }

  describe "scope" do

    context ".claims" do
      it { should respond_to(:claims) }
      it "returns all claims for user" do
        expect(user1.claims).to include(c1, c2)
        expect(user1.claims).not_to include(c3)
      end
    end

    context '.claims_to_receive' do
      it "returns claims that are owed to you" do
        expect(user1.claims_to_receive).to include(c1)
        expect(user1.claims_to_receive).not_to include(c2, c3)
      end
    end

    context ".claims_to_pay" do
      it "returns claims that you owe to other users" do
        expect(user1.claims_to_pay).to include(c2)
        expect(user1.claims_to_pay).not_to include(c1, c3)
      end
    end

  end

  describe "associations" do

    context "claims" do

      context "claims_to_receive" do
        it { should have_many(:claims_to_receive).dependent(:destroy) }
        it "returns only claims owed to the user" do
          expect(user1.claims_to_receive).to include(c1)
          expect(user1.claims_to_receive).not_to include(c2, c3)
        end
      end

      context "claims_to_pay" do
        it { should have_many(:claims_to_pay).dependent(:destroy) }
        it "returns only claims that the user owes" do
          expect(user1.claims_to_pay).to include(c2)
          expect(user1.claims_to_pay).not_to include(c1, c3)
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
      let(:com1) { FactoryGirl.create(:comment, claim: c1, user: user1) }
      let(:com2) { FactoryGirl.create(:comment, claim: c1, user: user2) }
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
