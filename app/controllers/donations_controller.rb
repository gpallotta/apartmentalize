class DonationsController < ApplicationController

  before_filter :authenticate_user!

  def new
    @donation = Donation.new
  end

  def create
  end

end
