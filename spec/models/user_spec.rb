require 'spec_helper'

describe User do

  describe "properties" do
    it { should respond_to(:email) }
    it { should respond_to(:encrypted_password) }
  end

  describe "validations" do
    context "email" do
      it { should validate_presence_of(:email)}
      it { should validate_uniqueness_of(:email) }
      it { should allow_value('greg@greg.com').for(:email) }
      it { should_not allow_value('greg@@greg.cpm').for(:email) }
    end

    context 'password' do
      it { should validate_presence_of(:password) }
      it { should validate_confirmation_of(:password) }
      it { should ensure_length_of(:password).is_at_least(8) }
    end

  end

end
