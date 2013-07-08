class UsersController < ApplicationController

  before_filter :authenticate_user!
  before_filter :other_user_profile

  def show
    @user = User.find(params[:id])
    @group = @user.group
  end

  protected

  def other_user_profile
    redirect_to user_root_path if params[:id] != current_user.id.to_s
  end

end
