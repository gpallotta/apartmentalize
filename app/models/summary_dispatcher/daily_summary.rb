module SummaryDispatcher
  class DailySummary

    def self.send_daily_summary
      users = User.subscribed_to_daily_email
      users.find_each { |u| UserMailer.daily_summary(u.id).deliver }
    end

  end
end
