//= require spec_helper

describe("marking claim paid", function() {

  var link = "<a href='#' data-id='1'>Hello</a>";

  beforeEach(function() {
    sinon.stub($, 'ajax').yieldsTo('success', {
      claim: { parsed_time: 'hello' }
    });
  });

  afterEach(function() {
    $.ajax.restore();
  });

  it("makes an ajax call", function() {
    markClaimPaid($(link), function() {});
    expect($.ajax.calledOnce).to.be.true;
  });

  describe("on claims index page", function() {
    it("updates the page after the ajax call", function() {
      markClaimPaid($(link), updateShowPageAfterPaid);
      // expect($('#mark-as-paid-error')).to.have.text('Chai Tea');
    });
  });

  describe("on claims show page", function() {
  });

});
