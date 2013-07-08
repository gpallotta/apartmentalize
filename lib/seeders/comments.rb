module Seeders
  module Comments

    class << self

      def seed
        Comment.destroy_all
        Claim.all.each do |claim|
          create_comment('This is a test comment', claim, claim.user_who_owes)
          create_comment('This is a test response', claim, claim.user_owed_to)
        end
      end

      def create_comment(content, claim, user)
        comment = Comment.new(content: content)
        comment.claim = claim
        comment.user = user
        comment.save
      end

    end

  end
end
