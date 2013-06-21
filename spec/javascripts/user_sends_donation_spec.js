//= require spec_helper

describe("user sends a donation", function() {

  var response = {
    "id": "tok_20mdE9oiA80MZ6"
  };

  beforeEach(function() {
    $('#konacha').append(HandlebarsTemplates['spec_templates/donations']());
    Stripe.setPublishableKey("pk_test_pcf69croxO3kQTlJ3Csy2yQd");
  });

  describe("with an invalid credit card", function() {
    it("returns an invalid token and displays errors", function() {
      Stripe.setPublishableKey("pk_test_pcf69croxO3kQTlJ3Csy2yQd");
      donation.processCard();
      setTimeout(function() {
        expect($('#stripe-error').text()).to.eql('This card number looks invalid');
      }, 5000);
    });
  });

  describe("with a valid credit card", function() {
    it("returns a valid token and submits form", function() {
      $('#card_number').val('4242424242424242');
      $('#card_code').val('123');

      donation.processCard();
      setTimeout(function() {
        expect( $('#donation_stripe_card_token').val() ).to.be(undefined);
      }, 5000);
      alert($('#donation_stripe_card_token').val());
    });
  });

});
