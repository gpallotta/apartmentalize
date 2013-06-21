jQuery(function() {
  $('.search-wrapper').hide();
  $('#claim-form-errors').hide();
  $('.create-button').addClass('active');
  window.formManipulations();
  var claimView = new ClaimView();
  claimView.addColorToClaims();

  $('#new_claim').submit(function(e) {
    e.preventDefault();
    c = new Claim();
    c.createClaims();
  });

  $('.mark-as-paid-link').click(function(e) {
    e.stopPropagation();
    e.preventDefault();
    c = new Claim();
    c.markClaimPaid($(this), c.claimView.updateIndexPageAfterPaid);
  });

  $('.show-page-mark-paid').click(function(e) {
    e.stopPropagation();
    e.preventDefault();
    c = new Claim();
    c.markClaimPaid($(this), c.claimView.updateShowPageAfterPaid);
  });

});

function Claim() {

  var that = this;
  this.claimView = new ClaimView();

  this.createClaims = function() {
    var form = $('#new_claim');
    $.ajax({
      url: form.attr('action') + '.json',
      type: "POST",
      data: form.serialize(),
      cache: false,
      dataType: 'JSON',
      success: function(result) {
        that.claimView.displayNewClaims(result);
      },
      error: function() {
        that.claimView.displayCreateErrors();
      }
    });
  };

  this.markClaimPaid = function(link, f) {
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
        that.claimView.displayMarkPaidErrors();
      }
    });
  };

}

function ClaimView() {

  var that = this;

  this.displayNewClaims = function(result) {
    var claim_num = result.claims.length;
    for(i = 0; i < claim_num; i++) {
      var claim = result.claims[i];
      html = HandlebarsTemplates['claims/create'](claim);
      $('.claims-table').append(html);
      $('.claims-table tr:last').hide().fadeIn();
      $('#claim-form-errors').hide();
    }
    $('#new_claim').find('input:text, input[type="number"]').val('');
    that.addColorToClaims();
  };

  this.displayMarkPaidErrors = function() {
    $('#mark-as-paid-error').text('Something went wrong');
  };

  this.displayCreateErrors = function() {
    $('#claim-form-errors').show();
  };

  this.updateShowPageAfterPaid = function(result) {
    $('#mark-as-paid-error').text('');
    $('.btn').addClass('disabled');
    $('.comment-button').removeClass('disabled');
    $('.edit-btn').text('Cannot edit paid claims');
    $('.edit-btn').attr('href', '#');
    $('.show-page-paid-status').text('Paid on ' + result.claim.parsed_time);
  };

  this.updateIndexPageAfterPaid = function(result, link) {
    link.hide(300);
    link.closest('tr').find('td:first').text('Paid');
    that.addColorToClaims();
  };

  this.addColorToClaims = function() {
    $('.claim-color').css('background-color', function() {
      if( $(this).closest('td').text().trim() == 'Unpaid') {
        return 'red';
      } else {
        return '#015959';
      }
    });
  };

}


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

  $(".search-button").click(function() {
    showSearchForm();
  });

  $(".create-button").click(function() {
    showClaimForm();
  });

};
