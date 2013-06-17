class ActivityPresenter
  attr_reader :activity

  def initialize(activity, view)
    @view = view
    @activity = activity
  end

  def render_activity
    v.div_for activity do
      render_partial
    end
  end

  def render_partial
    locals = {activity: activity, presenter: self}
    locals[activity.trackable_type.underscore.to_sym] = activity.trackable
    v.render partial_path, locals
  end

  def partial_path
    "activities/#{activity.trackable_type.underscore}/#{activity.action}"
  end

  def deleted_message
    "#{activity.owner.name} deleted this #{activity.trackable_type.downcase}"
  end


  private

  def v
    @view
  end

end
