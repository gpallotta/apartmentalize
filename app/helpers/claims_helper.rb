module ClaimsHelper

  def paid_status_for_show_page claim
    if claim.paid?
      "#{claim.paid_on.strftime("%B %d, %Y")}"
    else
      "Unpaid"
    end
  end

  def is_disabled?
    if @claim.paid?
      'disabled'
    end
  end

  def mark_as_paid_link
    if @claim.paid?
      content_tag(:a, 'Already paid', class: 'btn disabled')
    else
      link_to 'Mark as paid', mark_as_paid_claim_path(@claim), method: 'put', class: 'btn'
    end
  end

end
