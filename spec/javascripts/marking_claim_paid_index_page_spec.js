//= require spec_helper

describe("marking claim paid on index page", function() {

  var claim_object = {
    claim: {
      amount: 5,
      title: 'jstest',
      description: 'testdescription',
      paid: true
    }
  };

  beforeEach(function() {
    $('#konacha').append(JST['templates/marking_claim_paid_index_page']());
  });

  afterEach(function() {
    $.ajax.restore();
  });

  describe("success", function() {

    it("updates the page after a successful ajax call", function() {
      sinon.stub($, 'ajax').yieldsTo('success', claim_object);
      markClaimPaid( $('a'), updateIndexPageAfterPaid );
      expect( $('.mark-as-paid-link').is(":hidden")).to.be.true;
      expect($('td:first').text()).to.eql('Paid');
    });

  });

  describe("failure", function() {

    it("displays an error after an unsuccessufl ajax call", function() {
      sinon.stub($, 'ajax').yieldsTo('error', claim_object);
      markClaimPaid($('a'), function() {});
      expect( $('#mark-as-paid-error').text()).to.eql('Something went wrong');
    });

  });


});
