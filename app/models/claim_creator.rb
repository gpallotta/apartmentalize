class ClaimCreator
  attr_reader :all_valid, :created_claims, :user, :params

  def initialize user, params
    @user = user
    @params = params
    @all_valid = true
    @created_claims = []
  end

  def create_claims
    other_users.each do |u|
      if params[u.name]
        create_single_claim u
      end
    end
  end

  private

  def create_single_claim user_who_owes
    claim = Claim.new(params[:claim])
    claim.user_who_owes = user_who_owes
    claim.user_owed_to = user
    save_claim claim
  end

  def save_claim claim
    if claim.save
      @created_claims << claim
    else
      @all_valid = false
    end
  end

  def other_users
    other_users_arr = []
    user.group.users.each do |u|
      if u.id != user.id
        other_users_arr << u
      end
    end
    other_users_arr
  end

end
