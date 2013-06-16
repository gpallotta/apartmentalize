//= require spec_helper
describe("claim and search forms", function() {

  beforeEach(function() {
    var html = claimAndSearchHeaderButtons();
    appendTo('#konacha', html);
    window.formManipulations();
  });

  describe("clicking on search button", function() {

    beforeEach(function() {
      $('.create-button').click();
      $('.search-button').click();
    });

    it("shows the search form", function(){
      expect( $('.search-wrapper').is(":visible") ).to.be.true;
    });

    it("hides the new claim form", function() {
      setTimeout(function() {
        expect( $('.claim-form-wrapper').is(":hidden") ).to.be.true;
      }, 1000);
    });

    it('adds the active class to the search button', function() {
      expect( $('.search-button').hasClass('active') ).to.be.true;
    });

    it('removes the active class from the claim button', function() {
      expect( $('.create-button').hasClass('active') ).to.be.false;
    });

  });

  describe("clicking on claim button", function() {

    beforeEach(function() {
      $('.search-button').click();
      $('.create-button').click();
    });

    it("shows the create form", function() {
      expect($('.claim-form-wrapper').is(":visible")).to.be.true;
    });

    it("hides the search form", function() {
      setTimeout(function() {
        expect( $('.claim-form-wrapper').is(":hidden") ).to.be.true;
      }, 1000);
    });

    it('adds the active class to the claim button', function() {
      expect( $('.create-button').hasClass('active') ).to.be.true;
    });

    it('removes the active class from the search button', function() {
      expect( $('.search-button').hasClass('active') ).to.be.false;
    });

  });

});
