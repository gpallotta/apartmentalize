class RegistrationsController < Devise::RegistrationsController

  before_filter :authenticate_user!, only: [:edit, :update]

  def new
    super
  end

  def create
    # current_group = Group.find_by_identifier( cookies[:current_group_id] )
    @user = current_group.users.build( params[:user] )
    if @user.register
      sign_in @user
      redirect_to user_root_path
    else
      render 'new'
    end
  end

  def edit
    super
  end

  def update
    super
  end

  def destroy
    current_user.destroy
    redirect_to welcome_page_path
  end

  protected

  def after_update_path_for(resource)
    user_path(resource)
  end

end
