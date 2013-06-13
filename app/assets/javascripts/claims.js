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

  $('.mark-as-paid-link').click(function(e) {
    e.stopPropagation();
    e.preventDefault();
    markPaid($(this));
    // return false;
  });

  $('.show-page-mark-paid').click(function(e) {
    e.stopPropagation();
    e.preventDefault();
    showPageMarkPaid($(this));
  });

});

function showPageMarkPaid(link) {
  $.ajax({
    url: link.attr('href') + '.json',
    type: "PUT",
    data: { id: link.data('id') },
    cache: false,
    dataType: 'JSON',
    success: function() {
      updateShowPageAfterPaid(link);
    },
    error: function() {
    }
  });
}

function updateShowPageAfterPaid(link) {
  $('.btn').addClass('disabled');
  $('.comment-button').removeClass('disabled');
  $('.edit-btn').text('Cannot edit paid claims');
  $('.edit-btn').attr('href', '#');
}

function markPaid(link) {
  $.ajax({
    url: link.attr('href') + '.json',
    type: "PUT",
    data: { id: link.data('id') },
    cache: false,
    dataType: 'JSON',
    success: function() {
      updatePageAfterPaid(link);
    },
    error: function() {
    }
  });
}

function updatePageAfterPaid(link) {
  link.hide(300);
  link.closest('tr').find('td:first').text('Paid');
}

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
