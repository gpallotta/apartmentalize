require 'spec_helper'

describe CommentSerializer do

  let!(:comment) { FactoryGirl.create(:comment) }
  let!(:cs) { CommentSerializer.new(comment) }

  describe ".parsed_time" do
    it "returns a formatted string" do
      expect(cs.parsed_time).to eql( Time.now.utc.strftime("%B %d, %Y") )
    end
  end

end
