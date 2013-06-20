require 'spec_helper'

describe Donation do

  describe "properties" do
    it { should respond_to(:email) }
    it { should respond_to(:name) }
    it { should respond_to(:amount) }
  end

  describe "validations" do
    it { should have_valid(:email).when('greg@greg.com')}
    it { should_not have_valid(:email).when(nil)}

    it { should have_valid(:amount).when(50)}
    it { should_not have_valid(:amount).when(nil, 0, -1)}
  end

  describe ".save_with_payment" do
    it "creates a charge if the info is valid"
    it "does not create a charge if the info is invalid"
  end
end
