//= require spec_helper

describe("creating comments", function() {

  afterEach(function() {
    $.ajax.restore();
  });

  describe("success", function() {
    it("creates a comment and displays it", function() {
      sinon.stub($, 'ajax').yieldsTo('success', claim_object);
      comment = new Comment();
      comment.submitCommentForm( FORM GOES HERE );
    });
  });

  describe("error", function() {
    it("displays error text", function() {

    });
  });

});
