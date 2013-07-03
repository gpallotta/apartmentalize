//= require spec_helper

describe("creating comments", function() {

  beforeEach(function() {
    $('#konacha').append(HandlebarsTemplates['spec_templates/creating_comment']());
  });

  afterEach(function() {
    $.ajax.restore();
  });

  var comment_object = {
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
      sinon.stub($, 'ajax').yieldsTo('success', comment_object);
      // stub the Ajax call and callback
      $('#comment-form-errors').show();

      var comment = new Comment();
      comment.submitCommentForm($('#new_comment')); // Ajax call is made in this function
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
      $('#comment-form-errors').hide();
      sinon.stub($, 'ajax').yieldsTo('error');
      var comment = new Comment();
      comment.submitCommentForm($('#new_comment'));
      expect( $('#comment-form-errors').is(":hidden")).to.be.false;
    });
  });

});
