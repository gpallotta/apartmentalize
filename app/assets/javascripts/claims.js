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
        var str = '<div class="row"><div class="span3 offset2"><li><div>' +
                  '<span class="comment-bold">' + result.comment.user.name +
                  '</span> on <span class="comment-bold">' +
                  result.comment.parsed_time +
                  '</span></div><div class="comment-content">' +
                  result.comment.content +
                  '</div><p>' + result.comment.edit_link + '</p></li></div></div>';
        $('.comments-list').append(str);
        $('#comment-form-errors').hide();
        $("#new_comment").each(function() {
          this.reset();
        });
      },
      error: function() {
        $('#comment-form-errors').show();
      }
    });
  });

});
