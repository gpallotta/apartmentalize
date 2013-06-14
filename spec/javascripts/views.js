//= require jquery

appendTo = function(applicationRoot, html) {
  return $(applicationRoot).append(html);
};

claimButtons = function() {
  var str = '<div class="hide-button-wrapper">' +
              '<button class="btn hide-button create-button active">Create</button>' +
              '<button class="btn hide-button search-button">Search</button>' +
            '</div>' +
            '<div class="claim-form-wrapper">Create content</div>' +
            '<div class="search-wrapper">Search content</div>';
  return str;
};
