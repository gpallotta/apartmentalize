module ClaimsHelper

  def paid_status_for_show_page claim
    if claim.paid?
      "#{parse_time(claim.paid_on)}"
    else
      "Unpaid"
    end
  end

  def mark_paid_link_user_parse claim, user
    if claim.user_owed_to.id != user.id
      content_tag(:a, 'Not applicable', class: 'btn disabled', remote: true)
    else
      link_for_claim claim
    end
  end

  def link_for_claim claim
    if claim.paid?
      content_tag(:a, 'Already paid', class: 'btn disabled', remote: true)
    else
      link_to 'Mark as paid', mark_as_paid_claim_path(claim), method: 'put',
            class: 'btn', remote: true
    end
  end

  def user_checkbox_checked? name, search
    if search.checked_users && search.checked_users.include?(name)
      true
    end
  end

  def mark_as_paid_link_id claim
    "#{claim.id}-mark-paid-link"
  end

  def edit_claim_link claim, user
    if claim.user_who_owes.id == user.id
      content_tag(:a, 'Cannot edit', class: 'btn disabled', remote: true)
    else
      edit_link_for_paid_status claim
    end
  end

  def edit_link_for_paid_status claim
    if claim.paid?
      content_tag(:a, 'Cannot edit paid claims', class: 'btn disabled', remote: true)
    else
      link_to 'Edit', edit_claim_path(claim), class: 'btn'
    end
  end

end
