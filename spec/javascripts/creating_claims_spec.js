//= require spec_helper

describe("creating claims", function() {

  beforeEach(function() {
    $('#konacha').append(HandlebarsTemplates['spec_templates/creating_claim']());
  });

  afterEach(function() {
    $.ajax.restore();
  });

  var claim_object = {
    claims: [
      {
        id: 1,
        amount: "5",
        title: 'jstest',
        description: 'testdescription',
        paid: true,
        paid_status: 'Paid',
        parsed_time: 'Today',
        user_owed_to: {
          name: 'Greg'
        },
        user_who_owes: {
          name: 'Not Greg'
        }
      }
    ]
  };

  describe("success", function() {
    it("creates a claim and displays it", function() {
      sinon.stub($, 'ajax').yieldsTo('success', claim_object);
      $('#claim-form-errors').show();

      var claim = new Claim();
      claim.createClaims();

      expect( $('#claim-form-errors').is(":hidden")).to.be.true;
      var status = $('.claims-table td:first').text().replace(/\s/g,'');
      expect(status).to.eql('Paid');
      expect( $('.owed-to').text()).to.eql('Greg');
      expect( $('.owed-by').text()).to.eql('Not Greg');
      expect( $('.title div').text()).to.eql('jstest');
      expect( $('.description').text()).to.eql('testdescription');
      var amount = $('.amount').text().replace(/\s/g,'');
      expect(amount).to.eql('5');
      var created_on = $('.created-on').text().replace(/\s/g,'');
      expect(created_on).to.eql('Today');
    });
  });

  describe("error", function() {
    it("displays error text", function() {
      $('#claim-form-errors').hide();
      sinon.stub($, 'ajax').yieldsTo('error', claim_object);
      var claim = new Claim();
      claim.createClaims();

      expect( $('#claim-form-errors').is(":hidden")).to.be.false;
    });
  });

});
