require 'spec_helper'

describe Group do

  describe "properties" do
    it { should respond_to(:identifier) }
  end

  describe "validations" do
    it { should validate_presence_of(:identifier) }
    it { should have_many(:users).dependent(:destroy)}
  end

end
