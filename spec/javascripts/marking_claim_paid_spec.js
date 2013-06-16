//= require spec_helper

describe("marking claim paid", function() {

  describe("on claims index page", function() {
    beforeEach(function() {
      sinon.spy($, 'ajax');
    });

    it("makes an ajax call", function() {
      var link = "<a href='#' data-id='1'>Hello</a>";
      markClaimPaid($(link));
      expect($.ajax.calledOnce).to.be.true;
    });
  });

  describe("on claims show page", function() {

  });

});
