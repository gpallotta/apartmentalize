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
    balances = Hash.new(0)
    claims.each do |c|
      user_to_add = user_to_add_to c
      balances[user_to_add] += amount_sign c
    end
    balances
  end

  private

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
