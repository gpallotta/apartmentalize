require 'spec_helper'

describe ClaimSerializer do

  let!(:claim) { FactoryGirl.create(:claim) }
  let!(:cs) { CommentSerializer.new(claim) }

  describe ".parsed_time" do
    it "returns a formatted string" do
      expect(cs.parsed_time).to eql( Time.now.utc.strftime("%B %d, %Y") )
    end
  end

end
