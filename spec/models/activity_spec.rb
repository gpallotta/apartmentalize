require 'spec_helper'

describe Activity do

  describe "associations" do
    context "owner" do
      it { should belong_to(:owner) }
      it { should validate_presence_of(:owner) }
    end

    context "recipient" do
      it { should belong_to(:recipient) }
      it { should validate_presence_of(:recipient) }
    end

    context "trackable" do
      it { should belong_to(:trackable) }
      it { should validate_presence_of(:trackable) }
    end
  end

  describe "properties" do
    context "action" do
      it { should respond_to(:action) }
    end
  end

end
