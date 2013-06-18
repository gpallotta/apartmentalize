//= require spec_helper

describe("marking claim paid on index page", function() {

  beforeEach(function() {
    $('#konacha').append(JST['templates/marking_claim_paid_index_page']());
    sinon.stub($, 'ajax').yieldsTo('success', {
      claim: { parsed_time: 'hello',
      }
    });
  });

  afterEach(function() {
    $.ajax.restore();
  });

  it("updates the page after the ajax call", function() {
    markClaimPaid( $('a'), updateIndexPageAfterPaid );
    expect( $('.mark-as-paid-link').is(":hidden")).to.be.true;
    expect($('td:first').text()).to.eql('Paid');
  });

});
