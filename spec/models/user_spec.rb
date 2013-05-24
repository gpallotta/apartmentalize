# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)      not null
#  group_id               :integer          not null
#

require 'spec_helper'

describe User do

  describe "associations" do

    describe "scope" do
      let!(:group) { FactoryGirl.create(:group) }
      let!(:other_group) { FactoryGirl.create(:group) }
      let!(:other_user) { FactoryGirl.create(:user, group: other_group) }
      let!(:user1) { FactoryGirl.create(:user, group: group) }
      let!(:user2) { FactoryGirl.create(:user, group: group) }
      let!(:d1) { FactoryGirl.create(:debt, user_owed_to: user1, user_who_owes: user2) }
      let!(:d2) { FactoryGirl.create(:debt, user_owed_to: user2, user_who_owes: user1) }
      let!(:d3) { FactoryGirl.create(:debt, user_owed_to: other_user, user_who_owes: other_user) }

      context ".debts" do
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

    context "debts" do
      it { should have_many(:debts_owed_to).dependent(:destroy) }
      it { should have_many(:debts_they_owe).dependent(:destroy) }
    end

    context "chores" do
      it { should have_many(:chores) }
    end

    context "group" do
      it { should belong_to(:group) }
      it { should validate_presence_of(:group) }
    end

    context "comments" do
      it { should have_many(:comments) }
    end

    describe "scopes" do

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

  describe "methods" do
    it { should respond_to(:debts) }
  end

end
