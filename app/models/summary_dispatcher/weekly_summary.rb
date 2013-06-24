module SummaryDispatcher
  class WeeklySummary

    def self.send_weekly_summary
      users = User.subscribed_to_weekly_email
      users.find_each { |u| UserMailer.weekly_summary(u.id).deliver }
    end

  end
end
