//= require jquery
//= require chai-jquery
//= require claims
//= require views

describe("clicking on search button", function() {
  beforeEach(function() {
    var html = claimButtons();
    appendTo('#konacha', html);
    $('.create-button').click();
    $('.search-button').click();
  });

  it("shows the search form", function(){
    // expect($('.search-wrapper')).not.to.be.hidden;
    // expect($('body#konacha')).to.have.class('foo');
    // $('.search-wrapper').should.exist;
    $('.claim-form-wrapper').should.be.hidden;
    // $('body').should.exist;
    // expect($('body')).to.have.class('greg');
  });

});
