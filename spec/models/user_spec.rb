require 'spec_helper'

describe User do
  describe "properties" do
    it { should respond_to(:email) }
    it { should respond_to(:encrypted_password) }
  end

end
