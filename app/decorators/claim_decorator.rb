class ClaimDecorator < Draper::Decorator
  delegate_all

  def paid_on
    if object.paid?
      object.paid_on.strftime("%B %d, %Y")
    else
      "Unpaid"
    end
  end

  def mark_as_paid_link_id
    "#{object.id}-mark-paid-link"
  end

  def edit_link user
    if object.user_owed_to.id == user.id
      show_edit_link
    else
      h.content_tag(:a, 'Cannot edit', class: 'btn disabled')
    end
  end

  def mark_as_paid_link user
    if object.user_owed_to.id == user.id
      show_mark_as_paid_link
    else
      h.content_tag(:a, 'Cannot mark as paid', class: 'btn disabled')
    end
  end

  def paid_status
    if object.paid?
      'Paid'
    else
      'Unpaid'
    end
  end


  protected

  def show_edit_link
    if object.paid?
      h.content_tag(:a, 'Cannot edit paid claims', class: 'btn disabled')
    else
      h.link_to 'Edit', h.edit_claim_path(object), class: 'btn edit-btn'
    end
  end

  def show_mark_as_paid_link
    if object.paid?
      h.content_tag(:a, 'Already paid', class: 'btn disabled')
    else
      h.link_to 'Mark as paid', h.mark_as_paid_claim_path(object), method: 'put',
            class: 'btn show-page-mark-paid', :data => { :id => object.id }
    end
  end

end
