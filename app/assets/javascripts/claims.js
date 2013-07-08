function ClaimController() {

  var that = this;
  this.claim = new Claim();
  this.claimView = new ClaimView();

  this.submitForm = function() {
    var successCallback = that.claimView.displayNewClaims;
    var errorCallback   = that.claimView.displayCreateErrors;
    var data_to_post = {
      url:  $('#new_claim').attr('action') + '.json',
      info: $('#new_claim').serialize()
    };
    that.claim.createClaims(data_to_post, successCallback, errorCallback);
  };

  this.markPaid = function(link, updatePageFunction) {
    var successCallback = updatePageFunction;
    var errorCallback   = that.claimView.displayMarkPaidErrors;
    var dataObj = {
      url: link.attr('href') + '.json',
      id: link.data('id'),
      link: link
    };
    that.claim.markClaimPaid(dataObj, successCallback, errorCallback);
  };

}

function Claim() {

  var that = this;

  this.createClaims = function(dataObj, successCallback, errorCallback) {
    var form = $('#new_claim');
    $.ajax({
      url: dataObj.url,
      type: "POST",
      data: dataObj.info,
      cache: false,
      dataType: 'JSON',
      success: function(result) {
        successCallback(result);
      },
      error: function() {
        errorCallback();
      }
    });
  };

  this.markClaimPaid = function(dataObj, successCallback, errorCallback) {
    $.ajax({
      url: dataObj.url,
      type: "PUT",
      data: { id: dataObj.id },
      cache: false,
      dataType: 'JSON',
      success: function(result) {
        successCallback(result, dataObj.link);
      },
      error: function() {
        errorCallback();
      }
    });
  };

}

function ClaimView() {

  var that = this;
  this.claimColor = new ClaimColor();

  this.displayNewClaims = function(result) {
    var claim_num = result.claims.length;
    for(i = 0; i < claim_num; i++) {
      var claim = result.claims[i];
      html = HandlebarsTemplates['claims/create'](claim);
      $('.claims-table').append(html);
      $('.claims-table tr:last').hide().fadeIn();
      $('#claim-form-errors').hide();
    }
    $('#new_claim').
        find('input:text, input[type="number"], textarea').val('');
    that.claimColor.addColorToClaims();
  };

  this.displayMarkPaidErrors = function() {
    $('#mark-as-paid-error').text('Something went wrong');
  };

  this.displayCreateErrors = function(result) {
    $('#claim-form-errors').show();
  };

  this.updateShowPageAfterPaid = function(result) {
    $('#mark-as-paid-error').text('');
    $('.btn').addClass('disabled');
    $('.comment-button').removeClass('disabled');
    $('.edit-btn').text('Cannot edit paid claims');
    $('.edit-btn').attr('href', '#');
    $('.show-page-paid-status').text(result.claim.parsed_time);
  };

  this.updateIndexPageAfterPaid = function(result, link) {
    link.hide(300);
    link.closest('tr').find('td:first').text('Paid');
    that.claimColor.addColorToClaims();
  };

}

function ClaimColor() {

  var that = this;

  this.addColorToClaims = function() {
    $('.claim-color').css('background-color', function() {
      if( $(this).closest('td').text().trim() == 'Unpaid') {
        return '#721905';
      } else {
        return '#2C7C87';
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
