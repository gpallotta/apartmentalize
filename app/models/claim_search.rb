class ClaimSearch

  def initialize(user, params)
    @user = user
    @params = params
    @query = user.claims
  end

  def search
    build_query
  end


  protected

  def build_query
    add_title_desc
    add_amount
    add_paid_status
    add_users if @params[:z][:user_id]
    add_owed_status
    add_date_created
    add_date_paid
    return @query
  end

  def add_title_desc
    phrase = @params[:z][:title_or_description_cont]
    if phrase != ''
      phrase = "%#{phrase}%"
      @query = @query.where("title LIKE ? or description LIKE ?", phrase, phrase)
    end
  end

  def add_amount
    min = @params[:z][:amount_min]
    max = @params[:z][:amount_max]
    @query = @query.where("amount >= ?", min) if min != ''
    @query = @query.where("amount <= ?", max) if max != ''
  end

  def add_paid_status
    paid = @params[:z][:include_paid]
    unpaid = @params[:z][:include_unpaid]
    if paid && !unpaid
      @query = @query.where("paid = ?", true)
    elsif !paid && unpaid
      @query = @query.where("paid = ?", false)
    end
    # do nothing if both or none are selected
  end

  def add_owed_status
    to_receive = @params[:z][:to_receive]
    to_pay = @params[:z][:to_pay]
    if to_receive && !to_pay
      @query = @query.where("user_owed_to_id = ?", @user.id).joins(:user_owed_to)
    elsif !to_receive && to_pay
      @query = @query.where("user_who_owes_id = ?", @user.id).joins(:user_who_owes)
    end
    # do nothing if both or none are selected
  end

  def add_users
    @params[:z][:user_id].each do |other|
      @query = @query.where("user_who_owes_id = ? or user_owed_to_id = ?",
          other.to_i, other.to_i).joins(:user_owed_to, :user_who_owes)
    end
  end

  def add_date_created
    min = @params[:z][:date_created_min]
    max = @params[:z][:date_created_max]
    @query = @query.where("claims.created_at >= ?", format_date(min)) if min != ''
    @query = @query.where("claims.created_at <= ?", format_date(max)) if max != ''
  end

  def add_date_paid
    min = @params[:z][:date_paid_min]
    max = @params[:z][:date_paid_max]
    @query = @query.where("paid_on >= ?", format_date(min)) if min != ''
    @query = @query.where("paid_on <= ?", format_date(max)) if max != ''
  end

  def format_date(d)
    d += ' 00:00:00'
    DateTime.strptime(d, "%m/%d/%Y %H:%M:%S")
  end

end
