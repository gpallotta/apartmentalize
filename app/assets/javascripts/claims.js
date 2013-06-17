jQuery(function() {
  $('.search-wrapper').hide();
  $('.create-button').addClass('active');
  window.formManipulations();
});

window.formManipulations = function(){

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

  $('.user-label, .include-paid, .user-checkbox-label, .split-evenly').click(function() {
    $(this).toggleClass('active');
  });

  $('input:checked').each(function() {
    $(this).prev().addClass('active');
  });

  $('.mark-as-paid-link').click(function(e) {
    e.stopPropagation();
    e.preventDefault();
    markClaimPaid($(this), updateIndexPageAfterPaid);
  });

  $('.show-page-mark-paid').click(function(e) {
    e.stopPropagation();
    e.preventDefault();
    markClaimPaid($(this), updateShowPageAfterPaid);
  });

  $(".search-button").click(function() {
    showSearchForm();
  });

  $(".create-button").click(function() {
    showClaimForm();
  });

};

function markClaimPaid(link, f) {
  $.ajax({
    url: link.attr('href') + '.json',
    type: "PUT",
    data: { id: link.data('id') },
    cache: false,
    dataType: 'JSON',
    success: function(result) {
      f(result, link);
    },
    error: function() {
      $('#mark-as-paid-error').text('Something went wrong');
    }
  });
}

function updateShowPageAfterPaid(result) {
  $('#mark-as-paid-error').text('');
  $('.btn').addClass('disabled');
  $('.comment-button').removeClass('disabled');
  $('.edit-btn').text('Cannot edit paid claims');
  $('.edit-btn').attr('href', '#');
  $('.show-page-paid-status').text('Paid on ' + result.claim.parsed_time);
}

function updateIndexPageAfterPaid(result, link) {
  link.hide(300);
  link.closest('tr').find('td:first').text('Paid');
}

