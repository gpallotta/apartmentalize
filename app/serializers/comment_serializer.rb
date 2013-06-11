class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :user_id, :created_at, :edit_link, :parsed_time
  has_one :user

  def parsed_time
    object.created_at.strftime("%B %d, %Y")
  end

  def edit_link
    '<a href="/comments/#{object.id}/edit">Edit Comment</a>'
  end

end
