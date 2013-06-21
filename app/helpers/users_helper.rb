module UsersHelper

  def receive_weekly_email user
    if user.receives_weekly_email
      "You are receiving weekly email summaries"
    else
      "You are not receiving weekly email summaries"
    end
  end

  def receive_daily_email user
    if user.receives_daily_email
      "You are receiving daily email summaries"
    else
      "You are not receiving daily email summaries"
    end
  end

end
