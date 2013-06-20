//= require spec_helper

describe("user sends a donation", function() {

  beforeEach(function() {
    $('#konacha').append(HandlebarsTemplates['spec_templates/donations']());
  });

  describe("with a valid credit card", function() {
    it("returns a valid token and submits form", function() {
      var card = {
        number: $('#card_number').val(),
        cvc: $('#card_code').val(),
        expMonth: $('#card_month').val(),
        expYear: $('#card_year').val()
      };
    });
  });

  describe("with an invalid credit card", function() {
    it("returns an invalid token and displays errors", function() {
      // $('#stripe-error').hide();
      Stripe.setPublishableKey("pk_test_pcf69croxO3kQTlJ3Csy2yQd");
      donation.processCard();
      setTimeout(function() {
        expect($('#stripe-error').text()).to.eql('This card number looks invalid');
      }, 5000);

    });
  });

});
