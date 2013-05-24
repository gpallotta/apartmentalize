require 'spec_helper'

describe Group do

  describe "properties" do
    it { should respond_to(:identifier) }
  end

  describe "validations" do
    it { should validate_presence_of(:identifier) }
  end

end
