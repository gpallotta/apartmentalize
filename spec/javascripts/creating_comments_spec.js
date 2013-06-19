//= require spec_helper

describe("creating comments", function() {

  beforeEach(function() {
    $('#konacha').append(HandlebarsTemplates['spec/creating_comment']());
  });

  afterEach(function() {
    $.ajax.restore();
  });

  var claim_object = {
    comment: {
      content: 'This is a test',
      parsed_time: 'Today',
      user: {
        name: 'Greg'
      }
    }
  };

  describe("success", function() {
    it("creates a comment and displays it", function() {
      $('#comment_content').val('This is a test');
      sinon.stub($, 'ajax').yieldsTo('success', claim_object);
      comment = new Comment();
      comment.submitCommentForm($('#new_comment'));
      expect( $('#comment-form-errors').is(":hidden")).to.be.true;

      var name = $('.comments-list span:first').text().replace(/\s/g,'');
      expect(name).to.eql('Greg');

      var date = $('.comments-list span:nth-child(2)').text().replace(/\s/g,'');
      expect(date).to.eql('Today');

      expect( $('.comment-content').text()).to.eql('This is a test');
    });
  });

  describe("error", function() {
    it("displays error text", function() {
      sinon.stub($, 'ajax').yieldsTo('error');
      expect( $('#comment-form-errors').is(":hidden")).to.be.false;
    });
  });

});
