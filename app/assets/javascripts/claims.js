$(document).ready(function() {
  $(".btn").click(function() {
    $(this).toggleClass("active");
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
