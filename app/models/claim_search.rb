class ClaimSearch
  attr_reader :user, :claims, :params

  def initialize user, claims, params
    @user = user
    @claims = claims
    @params = params
  end

  def results
    owed_user_index
    title_or_description_contains
    amount_between
    paid_or_unpaid
    @claims
  end

  def owed_user_index
    to_receive_present, to_pay_present = params[:z][:to_receive], params[:z][:to_pay]
    if (to_receive_present && to_pay_present) || (!to_receive_present && !to_pay_present)
      # if no names passed in, do nothing
      # else return where z[user_name] include user_owed_to.name or user_who_owes.name
      to_receive_and_pay
    elsif to_receive_present
      # if no names passed in, return where user_owed_to is current_user
      # else return where user_owed_to is curret_user and z[user_name] include user_who_owes
      to_receive
    else
      # if no names are passed in, return where user_who_owes is current_user
      # else return where user_who_owes is current_user and z[user_name] include user_owed_to
      to_pay
    end
  end

  def to_receive_and_pay
    if params[:z][:user_name]
      name_list = params[:z][:user_name]
      @claims.select! { |c|  (name_list.include?(c.user_who_owes.name)) || (name_list.include?(c.user_owed_to.name)) }
    else
      @claims.select! { |c| (c.user_owed_to.id == user.id) || (c.user_who_owes.id == user.id) }
    end
  end

  def to_receive
    if params[:z][:user_name]
      @claims.select! { |c| c.user_owed_to.id == user.id && params[:z][:user_name].include?(c.user_who_owes.name) }
    else
      @claims.select! { |c| c.user_owed_to.id == user.id }
    end
  end

  def to_pay
    if params[:z][:user_name]
      @claims.select! { |c| c.user_who_owes.id == user.id && params[:z][:user_name].include?(c.user_owed_to.name) }
    else
      @claims.select! { |c| c.user_who_owes.id == user.id }
    end
  end

  def paid_or_unpaid
    if params[:z][:paid_status]
      @claims.select! do |c|
        params[:z][:paid_status].include? c.paid.to_s
      end
    end
  end

  def amount_between
    if params[:z][:amount_min] != '' && params[:z][:amount_min] != nil
      filter_claims_by_min_amount if params[:z][:amount_min]
    end
    if params[:z][:amount_max] != '' && params[:z][:amount_max] != nil
      filter_claims_by_max_amount if params[:z][:amount_max]
    end
  end

  def filter_claims_by_min_amount
    @claims.select! { |c| c.amount >= params[:z][:amount_min].to_f }
  end

  def filter_claims_by_max_amount
    @claims.select! { |c| c.amount <= params[:z][:amount_max].to_f }
  end

  def title_or_description_contains
    phrase = params[:z][:title_or_description_cont]
    if phrase != '' && phrase != nil
      @claims.select! do |c|
        string_nil(c.title).include?(phrase) || string_nil(c.description).include?(phrase)
      end
    end
  end

  def string_nil str
    if str.nil?
      ''
    else
      str
    end
  end

end
