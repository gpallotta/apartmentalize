class ClaimSearch < ActiveRecord::Base
  attr_reader :user, :claims, :params, :amount_min, :amount_max,
              :title_desc, :checked_users, :include_paid, :include_unpaid,
              :include_to_pay, :include_to_receive

  def initialize user, claims, params
    @user = user
    @claims = claims
    @params = params
    set_search_instance_vars
  end

  def set_search_instance_vars
    if params[:z]
      @amount_min = params[:z][:amount_min]
      @amount_max = params[:z][:amount_max]
      @title_desc = params[:z][:title_or_description_cont]
      @checked_users = params[:z][:user_name]
      @include_paid = params[:z][:paid_status].include? 'true'
      @include_unpaid = params[:z][:paid_status].include? 'false'
      @include_to_receive = params[:z][:to_receive]
      @include_to_pay = params[:z][:to_pay]
    end
  end

  def results
    if params[:z]
      owed_user_index
      title_or_description_contains
      amount_between
      paid_or_unpaid
    end
    @claims
  end

  def owed_user_index
    to_receive_present, to_pay_present = params[:z][:to_receive], params[:z][:to_pay]
    if (to_receive_present && to_pay_present) || (!to_receive_present && !to_pay_present)
      to_receive_and_pay
    elsif to_receive_present
      to_receive
    else
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
