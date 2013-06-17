require 'spec_helper'

describe Activity do

  describe "associations" do
    context "owner" do
      it { should belong_to(:owner) }
      it { should have_valid(:owner).when(User.new) }
      it { should_not have_valid(:owner).when(nil) }
    end

    context "recipient" do
      it { should belong_to(:recipient) }
      it { should have_valid(:recipient).when(User.new) }
      it { should_not have_valid(:recipient).when(nil) }
    end

    context "trackable" do
      it { should belong_to(:trackable) }
      it { should have_valid(:trackable).when(Claim.new, Comment.new) }
      it { should_not have_valid(:trackable).when(nil) }
    end
  end

  describe "properties" do
    it { should respond_to(:action) }
    it { should respond_to(:trackable_type) }
  end

end
