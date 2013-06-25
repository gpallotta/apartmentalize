class DonationsController < ApplicationController

  before_filter :authenticate_user!

  def new
    @donation = Donation.new
  end

  def create
    @donation = current_user.donations.build(
      name: params[:name],
      email: params[:email],
      amount: params[:amount],
      stripe_card_token: params[:stripe_card_token]
    )

    respond_to do |format|
      if @donation.save_with_payment
        format.json {
          render :json => {
            :redirect_url => home_page_path,
            :status_code => "200"
          }
        }
      else
        format.json
      end
    end

  end

end
