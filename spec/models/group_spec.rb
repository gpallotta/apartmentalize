# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  identifier :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Group do

  describe "properties" do

    context "identifier" do
      it { should respond_to(:identifier) }
      it { should validate_presence_of(:identifier) }
    end

  end

  describe "associations" do

    context "users" do
      it { should have_many(:users).dependent(:destroy) }
    end

    context "chores" do
      it { should have_many(:chores).dependent(:destroy) }
    end

    context "managers" do
      it { should have_many(:managers).dependent(:destroy) }
    end

  end

end
