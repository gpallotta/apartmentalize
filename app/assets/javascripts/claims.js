$(document).ready(function() {

  $('.user-label, .include-paid, .user-checkbox-label').click(function() {
    $(this).toggleClass('active');
  });

  $('input:checked').each(function() {
    $(this).prev().addClass('active');
  });

  $(".search-button").click(function() {
    showSearchForm();
  });

  $(".create-button").click(function() {
    showClaimForm();
  });

  var comment_source = $('#comment-template').html();
  var template = Handlebars.compile(comment_source);

  $('#new_comment').submit(function(e) {
    e.preventDefault();
    submitCommentForm(this, template);
  });

});

function increaseCommentCount() {
  var num = $('#comment-number').html();
  num = parseInt(num, 10);
  $('#comment-number').html(num+1);
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
      var html = template(result);
      $('.comments-list').append(html);
      $('#comment-form-errors').hide();
      $('#new_comment')[0].reset();
      increaseCommentCount();
    },
    error: function() {
      $('#comment-form-errors').show();
    }
  });
}

function showSearchForm() {
  $('.search-wrapper').removeClass("hidden");
  $('.claim-form-wrapper').addClass("hidden");
  $('.create-button').removeClass("active");
  $('.search-button').addClass("active");
}

function showClaimForm() {
  $('.search-wrapper').addClass("hidden");
  $('.claim-form-wrapper').removeClass("hidden");
  $('.create-button').addClass('active');
  $('.search-button').removeClass('active');
}
