$(document).ready(function() {

  $('.search-wrapper').hide();
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

});

function showClaimForm() {
  $('.search-wrapper').hide(300);
  $('.claim-form-wrapper').show(300);
  $('.create-button').addClass('active');
  $('.search-button').removeClass('active');
}

function showSearchForm() {
  $('.claim-form-wrapper').hide(300);
  $('.search-wrapper').show(300);
  $('.create-button').removeClass("active");
  $('.search-button').addClass("active");
}
