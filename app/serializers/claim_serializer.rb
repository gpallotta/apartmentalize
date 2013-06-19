class ClaimSerializer < ActiveModel::Serializer
  attributes :id, :parsed_time, :amount, :title, :description, :paid, :paid_status
  has_one :user_owed_to
  has_one :user_who_owes

  def parsed_time
    object.created_at.strftime("%B %d, %Y")
  end

  def paid_status
    if object.paid
      "Paid"
    else
      "Unpaid"
    end
  end

end
