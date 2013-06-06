class ActivitiesController < ApplicationController

  def index
    @activities = Activity.order("created_at DESC")
  end

  def render_activity
  end

end
