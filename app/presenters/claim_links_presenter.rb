class ClaimLinksPresenter
  attr_reader :claim, :view

  def initialize(claim, view)
    @claim = claim
    @view = view
  end

  def paid_on
    if claim.paid?
      "#{parse_time(claim.paid_on)}"
    else
      "Unpaid"
    end
  end

  def mark_as_paid_link_id
    "#{claim.id}-mark-paid-link"
  end

  def edit_link user
    if claim.user_owed_to.id == user.id
      show_edit_link
    else
      view.content_tag(:a, 'Cannot edit', class: 'btn disabled')
    end
  end

  def mark_as_paid_link user
    if claim.user_owed_to.id == user.id
      show_mark_as_paid_link
    else
      view.content_tag(:a, 'Cannot mark as paid', class: 'btn disabled')
    end
  end

  protected

  def show_edit_link
    if claim.paid?
      view.content_tag(:a, 'Cannot edit paid claims', class: 'btn disabled')
    else
      view.link_to 'Edit', view.edit_claim_path(claim), class: 'btn edit-btn'
    end
  end

  def show_mark_as_paid_link
    if claim.paid?
      view.content_tag(:a, 'Already paid', class: 'btn disabled')
    else
      view.link_to 'Mark as paid', view.mark_as_paid_claim_path(claim), method: 'put',
            class: 'btn show-page-mark-paid', :data => { :id => claim.id }
    end
  end

end
