class DonationsController < ApplicationController

  before_filter :authenticate_user!

  def new
    @donation = Donation.new
  end

  def create
    @donation = current_user.donations.build(params[:donation])
    binding.pry
    if @donation.save_with_payment
      redirect_to home_page_path, :notice => 'Thank you for donating'
    else
      render :new
    end
  end

end
