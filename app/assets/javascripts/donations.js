window.donation = {
  setupForm: function() {
    $('#new_donation').submit(function(e) {
      e.preventDefault();
      $('input[type=submit]').attr('disabled', true);
      donation.processCard();
      return false;
    });
  },

  processCard: function() {
    var card = {
      number: $('#card_number').val(),
      cvc: $('#card_code').val(),
      expMonth: $('#card_month').val(),
      expYear: $('#card_year').val()
    };
    Stripe.createToken(card, donation.handleStripeResponse);
  },

  handleStripeResponse: function(status, response) {
    if (status == 200) {
      $('#donation_stripe_card_token').val(response.id);
      $('#new_donation')[0].submit();
    } else {
      $('#stripe-error').text(response.error.message);
      $('input[type=submit]').attr('disabled', false);
    }
  }
};
