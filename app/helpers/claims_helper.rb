module ClaimsHelper

  def paid_status_for_show_page claim
    if claim.paid?
      "#{}"
    else
      "Unpaid"
    end
  end

end
