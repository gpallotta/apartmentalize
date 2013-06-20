window.donation = {
  setupForm: function() {
    $('#new_donation').submit(function() {
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
      alert(response.id);
    } else {
      alert(response.error.message);
      $('input[type=submit]').attr('disabled', false);
    }
  }
};
