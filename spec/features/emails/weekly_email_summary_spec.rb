require 'spec_helper'

describe "weekly summary email" do

  describe "content" do
    it "has a link to the claims page"
    it "has a link to the chores page"
    it "has a link to the home page"
    it "has any chores assigned to the user for the week"
    it "has the activity feed"
    it "has the total balance between you and all users"
    it "has the balance between you and each individual user"
  end

  describe "opting in" do
    it "causes the user to receive the email"
  end

  describe "opting out" do
    it "causes the user to not receive the email"
  end

end
