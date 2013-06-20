class Donation < ActiveRecord::Base

  validates_presence_of :email
  validates_presence_of :amount
  validates_numericality_of :amount, :greater_than => 0

  attr_accessible :email, :name, :amount, :stripe_card_token

  attr_accessor :stripe_card_token

  def save_with_payment
    if valid?
      begin
        charge = Stripe::Charge.create(
          :amount => amount*100,
          :currency => 'usd',
          :card => stripe_card_token,
          :description => "Donation from #{name}"
        )
      save!
      rescue Stripe::CardError => e
        logger.error "Stripe error while creating charge: #{e.message}"
        errors.add :base, "There was a problem with your credit card."
      end
    end
  end

end
