# == Schema Information
#
# Table name: managers
#
#  id           :integer          not null, primary key
#  title        :string(255)      not null
#  name         :string(255)      not null
#  phone_number :string(255)      not null
#  address      :string(255)      not null
#  group_id     :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Manager do

  describe "properties" do

    context "name" do
      it { should respond_to(:name) }
      it { should validate_presence_of(:name) }
    end

    context "title" do
      it { should respond_to(:title) }
      it { should validate_presence_of(:title) }
    end

    context "phone_number" do
      it { should respond_to(:phone_number) }
      it { should validate_presence_of(:phone_number) }
      it { should ensure_length_of(:phone_number).is_equal_to(10) }
      it { should allow_value('1234567890').for(:phone_number) }
      it { should_not allow_value('a234567890').for(:phone_number) }
    end

    context "address" do
      it { should respond_to(:address) }
      it { should validate_presence_of(:address) }
    end

  end

  describe "associations" do
    context "group" do
      it { should belong_to(:group) }
      it { should validate_presence_of(:group) }
    end
  end

end
