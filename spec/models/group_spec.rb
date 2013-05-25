require 'spec_helper'

describe Group do

  describe "properties" do

    context "identifier" do
      it { should respond_to(:identifier) }
      it { should validate_presence_of(:identifier) }
    end

  end

  describe "associations" do

    let(:group) { FactoryGirl.create(:group) }
    let(:user1) { FactoryGirl.create(:user, group: group) }
    let(:other_group) { FactoryGirl.create(:group) }
    let(:other_user) { FactoryGirl.create(:user, group: other_group) }

    context "users" do
      it { should have_many(:users).dependent(:destroy) }
      it "returns the correct users" do
        expect(group.users).to include(user1)
        expect(group.users).not_to include(other_user)
      end
    end

    context "chores" do
      let(:ch1) { FactoryGirl.create(:chore, user: user1, group: group) }
      let(:ch2) { FactoryGirl.create(:chore, user: user1, group: other_group) }

      it { should have_many(:chores).dependent(:destroy) }
      it "returns the correct chores" do
        expect(group.chores).to include(ch1)
        expect(group.chores).not_to include(ch2)
      end
    end

    context "managers" do
      let(:m1) { FactoryGirl.create(:manager, group: group)}
      let(:m2) { FactoryGirl.create(:manager, group: other_group)}
      it { should have_many(:managers).dependent(:destroy) }
      it "returns the correct managers" do
        expect(group.managers).to include(m1)
        expect(group.managers).not_to include(m2)
      end
    end

  end

end
