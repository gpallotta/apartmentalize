$(function() {

  var comment_source = $('#comment-template').html();
  var template = Handlebars.compile(comment_source);

  $('#new_comment').submit(function(e) {
    e.preventDefault();
    submitCommentForm(this, template);
  });

  function increaseCommentCount() {
    var num = $('#comment-number').html();
    num = parseInt(num, 10);
    $('#comment-number').html(num+1);
  }

  function addComment(comment) {
    var html = template(comment);
    $('.comments-list').append(html);
    $('.comments-list div.row:last').hide().fadeIn();
    $('#comment-form-errors').hide();
    $('#new_comment')[0].reset();
    increaseCommentCount();
  }

  function submitCommentForm(form_submitted, template) {
    var form = $(form_submitted);
    $.ajax({
      url: form.attr('action') + '.json',
      type: "POST",
      data: form.serialize(),
      cache: false,
      dataType: "JSON",
      success: function(result) {
        addComment(result);
      },
      error: function() {
        $('#comment-form-errors').show();
      }
    });
  }
});
