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
        var display = '<div class="row"> <div class="span3 offset2"> <li> <div> <span class="comment-bold"> <%= comment.user.name %> </span> on <span class="comment-bold"> <%= parse_time(comment.created_at) %> </span> </div> <div class="comment-content"><%= comment.content %></div> <% if comment.user.id == current_user.id %> <p><%= link_to "Edit Comment", edit_comment_path(comment) %></p> <% end %> </li> </div> </div>';

        $('.comments-list').append(display);
      },
      error: function() {
        alert('oh no');
      }
    });
  });

});
