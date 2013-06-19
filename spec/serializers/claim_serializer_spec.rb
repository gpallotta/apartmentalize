require 'spec_helper'

describe ClaimSerializer do

  let(:claim) { FactoryGirl.create(:claim) }
  let(:cs) { ClaimSerializer.new(claim) }

  describe ".parsed_time" do
    it "returns a formatted string" do
      expect(cs.parsed_time).to eql( Time.now.utc.strftime("%B %d, %Y") )
    end
  end

  describe ".paid_status" do
    it "returns Unpaid if the claim is unpaid" do
      expect(cs.paid_status).to eql('Unpaid')
    end

    it "returns Paid is the claim is paid" do
      claim.update_attributes(paid: true)
      cs = ClaimSerializer.new(claim)
      expect(cs.paid_status).to eql('Paid')
    end

  end

end
