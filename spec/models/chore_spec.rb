require 'spec_helper'

describe Chore do

  let(:group) { FactoryGirl.create(:group) }
  let(:user1) { FactoryGirl.create(:user, group: group) }
  let(:ch1) { FactoryGirl.create(:chore, group: group, user: user1) }

  describe "associations" do

    context "group" do
      it { should belong_to(:group) }
      it { should validate_presence_of(:group) }
      it "sets the correct group" do
        expect(ch1.group).to eql(group)
      end
    end

    context "user" do
      it { should belong_to(:user) }
      it { should validate_presence_of(:user) }
      it "sets the correct user" do
        expect(ch1.user).to eql(user1)
      end
    end

  end

  describe "properties" do

    context "title" do
      it { should respond_to(:title) }
      it { should validate_presence_of(:title) }
    end

    context "description" do
      it { should respond_to(:description) }
      it { should validate_presence_of(:description) }
    end

    context "completed" do
      it { should respond_to(:completed) }
    end
  end



end
