require 'spec_helper'

describe CommentSerializer do

  let!(:comment) { FactoryGirl.create(:comment) }
  let!(:cs) { CommentSerializer.new(comment) }

  describe ".parsed_time" do
    it "returns a formatted string" do
      expect(cs.parsed_time).to eql( Time.now.utc.strftime("%B %d, %Y") )
    end
  end

  describe ".edit_link" do
    it "returns an edit link to the comment" do
      expect(cs.edit_link).to include("/edit", "Edit Comment", "</a>")
    end
  end

end
