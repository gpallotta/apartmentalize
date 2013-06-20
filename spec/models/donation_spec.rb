require 'spec_helper'

describe Donation do

  describe "properties" do
    it { should respond_to(:email) }
    it { should respond_to(:name) }
  end

  describe "validations" do
    it { should validate_presence_of(:email) }
  end
end
