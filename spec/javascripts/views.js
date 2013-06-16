//= require jquery

appendTo = function(applicationRoot, html) {
  return $(applicationRoot).append(html);
};

claimAndSearchHeaderButtons = function() {
  var str = '<div class="hide-button-wrapper">' +
              '<button class="btn hide-button create-button active">Create</button>' +
              '<button class="btn hide-button search-button">Search</button>' +
            '</div>' +
            '<div class="claim-form-wrapper">Create content</div>' +
            '<div class="search-wrapper">Search content</div>';
  return str;
};

claimAndSearchFormButtons = function() {
  var str = '<%= label_tag "to-receive", "To receive from", class: "user-label btn" %>' +
            '<%= label_tag "unpaid-checkbox", "Unpaid", class: "include-paid btn" %>' +
      '<%= label_tag other.name, other.name, class: "btn active user-checkbox-label" %>' +
    '<%= label_tag "split_evenly", "Split evenly", { class: "btn split-evenly" } %>';
    return str;
};
