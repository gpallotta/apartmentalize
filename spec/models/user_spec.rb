# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  name                   :string(255)      not null
#

require 'spec_helper'

describe User do

  describe "properties" do
    it { should respond_to(:email) }
    it { should respond_to(:name) }
    it { should respond_to(:encrypted_password) }
  end

  describe "validations" do

    context 'name' do
      it { should validate_presence_of(:name) }
    end

    context "email" do
      it { should validate_presence_of(:email)}

      it "validates uniqueness of email" do
        User.new(name: 'Greg', email: 'greg@greg.com', password: '12345678',
                  password_confirmation: '12345678').save!
        should validate_uniqueness_of(:email)
      end # without creation, null constraint on name is violated

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
