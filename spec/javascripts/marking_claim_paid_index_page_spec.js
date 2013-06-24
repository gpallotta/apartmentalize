//= require spec_helper

describe("marking claim paid on index page", function() {

  var claim_object = {
    id: 1,
    amount: 5,
    title: 'jstest',
    description: 'testdescription',
    paid: true,
    paid_status: 'Paid',
    parsed_time: 'June 1, 2020',
    user_owed_to: {
      name: 'Greg'
    },
    user_who_owes: {
      name: 'Not Greg'
    }
  };

  beforeEach(function() {
    $('#konacha').append(HandlebarsTemplates['claims/create'](claim_object));
    $('#konacha').append('<div id="mark-as-paid-error"></div>');
  });

  afterEach(function() {
    $.ajax.restore();
  });

  describe("success", function() {

    it("updates the page after a successful ajax call", function() {
      c = new ClaimController();
      sinon.stub($, 'ajax').yieldsTo('success', claim_object);
      c.markPaid( $('a'), c.claimView.updateIndexPageAfterPaid );
      expect( $('.mark-as-paid-link').is(":hidden")).to.be.true;
      expect($('td:first').text()).to.eql('Paid');
    });

  });

  describe("failure", function() {

    it("displays an error after an unsuccessufl ajax call", function() {
      c = new ClaimController();
      sinon.stub($, 'ajax').yieldsTo('error', claim_object);
      c.markPaid($('a'), function() {});
      expect( $('#mark-as-paid-error').text()).to.eql('Something went wrong');
    });

  });


});
