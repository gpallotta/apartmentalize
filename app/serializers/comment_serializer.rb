class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :user_id, :created_at, :parsed_time
  has_one :user

  def parsed_time
    object.created_at.strftime("%B %d, %Y")
  end

end
