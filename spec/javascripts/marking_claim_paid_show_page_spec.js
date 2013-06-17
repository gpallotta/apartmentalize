//= require spec_helper

describe("marking claim paid on show page", function() {

  beforeEach(function() {
    $('#konacha').append(JST['templates/marking_claim_paid_show_page']());
    sinon.stub($, 'ajax').yieldsTo('success', {
      claim: { parsed_time: 'hello' }
    });
    markClaimPaid($('a'), updateShowPageAfterPaid);
  });

  afterEach(function() {
    $.ajax.restore();
  });

  it("makes an ajax call", function() {
    expect($.ajax.calledOnce).to.be.true;
  });

  it("updates the page after the ajax call", function() {
    expect( $('.edit-btn').text()).to.eql('Cannot edit paid claims');
    expect( $('mark-as-paid-error').text()).to.eql('');
    expect( $('.btn').hasClass('disabled')).to.be.true;
    expect( $('.comment-button').hasClass('disabled')).to.be.false;
    expect( $('.edit-btn').attr('href')).to.eql('#');
  });

});
