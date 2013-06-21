//= require spec_helper

describe("marking claim paid on show page", function() {

  it("updates the page after the ajax call", function() {
    $('#konacha').append(HandlebarsTemplates['spec_templates/marking_claim_paid_show_page']());
    sinon.stub($, 'ajax').yieldsTo('success', {
      claim: { parsed_time: 'hello' }
    });
    c = new Claim();
    c.markClaimPaid($('a'), c.claimView.updateShowPageAfterPaid);

    expect( $('.edit-btn').text()).to.eql('Cannot edit paid claims');
    expect( $('mark-as-paid-error').text()).to.eql('');
    expect( $('.btn').hasClass('disabled')).to.be.true;
    expect( $('.comment-button').hasClass('disabled')).to.be.false;
    expect( $('.edit-btn').attr('href')).to.eql('#');
  });

});
