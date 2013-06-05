class ClaimBalance
  attr_reader :user, :claims

  def initialize user, claims
    @user = user
    @claims = claims
  end

  def total
    total = 0
    @claims.each { |c| total += amount_sign c }
    total
  end

  def user_balances
    balances = initialize_hash
    claims.each do |c|
      user_to_add = user_to_add_to c
      balances[user_to_add] += amount_sign c
    end
    balances
  end

  def initialize_hash
    balances = Hash.new(0)
    other_users.each do |u|
      balances[u.name] = 0
    end
    balances
  end


  private

  def other_users
    others = []
    user.group.users.each do |u|
      if u.id != user.id
        puts u.name
        others << u
      end
    end
    others
  end

  def user_to_add_to c
    if c.user_owed_to == user
      c.user_who_owes.name
    else
      c.user_owed_to.name
    end
  end

  def amount_sign c
    if c.user_owed_to == user
      c.amount
    else
      -c.amount
    end
  end

  def add_into_amount balances, c
    if c.user_owed_to != user # owed_owed_to is someone else
      balances[c.user_owed_to] -= c.amount
    else # user_owed_to is you
      balances[c.user_who_owes] += c.amount
    end
  end


end
