require 'spec_helper'

describe Comment do

  describe "properties" do
    it { should respond_to(:content) }
    it { should respond_to(:user_id) }
    it { should respond_to(:debt_id) }
  end

  describe "validations" do

    context "content" do
      it { should validate_presence_of(:content) }
    end

    context "associations" do
      it { should belong_to(:debt) }
      it { should validate_presence_of(:debt) }
      it { should belong_to(:user) }
      it { should validate_presence_of(:user) }
    end

  end
end
