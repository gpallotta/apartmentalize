require 'spec_helper'

describe Manager do

  describe "associations" do

    let(:group) { FactoryGirl.create(:group) }
    let(:m1) { FactoryGirl.create(:manager, group: group)}

    context "group" do
      it { should belong_to(:group) }
      it { should validate_presence_of(:group) }
      it "sets the correct group" do
        expect(m1.group).to eql(group)
      end
    end
  end

  describe "properties" do

    context "name" do
      it { should respond_to(:name) }
      it { should validate_presence_of(:name) }
    end

    context "title" do
      it { should respond_to(:title) }
      it { should validate_presence_of(:title) }
    end

    context "email" do
      it { should respond_to(:email) }
    end

    context "phone_number" do
      it { should respond_to(:phone_number) }
      it { should ensure_length_of(:phone_number).is_equal_to(10) }
      it { should allow_value('1234567890').for(:phone_number) }
      it { should_not allow_value('a234567890').for(:phone_number) }
    end

    context "address" do
      it { should respond_to(:address) }
    end

  end



end
