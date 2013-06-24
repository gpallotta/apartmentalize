function Comment() {

  var that = this;

  this.commentView = new CommentView();

  this.submitCommentForm = function(form_submitted) {
    var form = $(form_submitted);
    $.ajax({
      url: form.attr('action') + '.json',
      type: "POST",
      data: form.serialize(),
      cache: false,
      dataType: "JSON",
      success: function(result) {
        that.commentView.displayComment(result);
      },
      error: function() {
        that.commentView.displayError();
      }
    });
  };

}

function CommentView() {

  var that = this;

  this.displayError = function() {
    $('#comment-form-errors').show();
  };

  this.displayComment = function(comment) {
    html = HandlebarsTemplates['comments/create'](comment);
    $('.comments-list').append(html);
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

}
