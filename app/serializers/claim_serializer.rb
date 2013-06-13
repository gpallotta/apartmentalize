class ClaimSerializer < ActiveModel::Serializer
  attributes :id, :parsed_time

  def parsed_time
    object.created_at.strftime("%B %d, %Y")
  end

end
