jQuery(function() {

  $('#new_comment').submit(function(e) {
    e.preventDefault();
    c = new Comment();
    c.submitCommentForm(this);
  });

});


function Comment() {

  var that = this;
  this.template = Handlebars.compile( $('#comment-template').html() );

  this.addComment = function(comment) {
    $('.comments-list').append( that.template(comment) );
    $('.comments-list div.row:last').hide().fadeIn();
    $('#comment-form-errors').hide();
    $('#new_comment')[0].reset();
    that.increaseCommentCount();
  };

  this.increaseCommentCount = function() {
    var num = $('#comment-number').html();
    num = parseInt(num, 10);
    $('#comment-number').html(num+1);
  };

  this.submitCommentForm = function(form_submitted) {
    var form = $(form_submitted);
    $.ajax({
      url: form.attr('action') + '.json',
      type: "POST",
      data: form.serialize(),
      cache: false,
      dataType: "JSON",
      success: function(result) {
        that.addComment(result);
      },
      error: function() {
        that.displayError();
      }
    });
  };

  this.displayError = function() {
    $('#comment-form-errors').show();
  };

}
