$(document).ready(function() {

  $('.user-label, .include-paid, .user-checkbox-label').click(function() {
    $(this).toggleClass('active');
  });

  $('input:checked').each(function() {
    $(this).prev().addClass('active');
  });

  $(".search-button").click(function() {
    $('.search-wrapper').removeClass("hidden");
    $('.claim-form-wrapper').addClass("hidden");
    $('.create-button').removeClass("active");
    $('.search-button').addClass("active");
  });

  $(".create-button").click(function() {
    $('.search-wrapper').addClass("hidden");
    $('.claim-form-wrapper').removeClass("hidden");
    $('.create-button').addClass('active');
    $('.search-button').removeClass('active');
  });

  var comment_source = $('#comment-template').html();
  var template = Handlebars.compile(comment_source);

  $('#new_comment').submit(function(e) {
    e.preventDefault();
    var form = $(this);
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
      },
      error: function() {
        $('#comment-form-errors').show();
      }
    });
  });

});
