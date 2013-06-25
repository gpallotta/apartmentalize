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
    $('#loading').show();
    Stripe.createToken(card, donation.handleStripeResponse);
  },

  handleStripeResponse: function(status, response) {
    if (status == 200) {
      donation.submitForm(response.id);
    } else {
      $('#stripe-error').text(response.error.message);
      $('input[type=submit]').attr('disabled', false);
      $('#loading').hide();
    }
  },

  submitForm: function(token) {
    $.ajax({
      url: $('#new_donation').attr('action') + '.json',
      type: "POST",
      data: {
        stripe_card_token: token,
        email: $('#donation_email').val(),
        name: $('#donation_name').val(),
        amount: $('#donation_amount').val()
      },
      cache: false,
      dataType: 'JSON',
      success: function(result) {
        window.location.href = result.redirect_url;
      },
      error: function() {
        $('#loading').hide();
      }
    });
  }
};
