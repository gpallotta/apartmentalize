$(document).ready(function() {
  // $(".btn").click(function() {
  //   $(this).toggleClass("active");
  // });

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

});
