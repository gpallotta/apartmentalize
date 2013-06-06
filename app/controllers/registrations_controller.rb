class RegistrationsController < Devise::RegistrationsController

  before_filter :authenticate_user!, only: [:edit, :update]

  def new
    super
  end

  def create
    @user = current_group.users.build( params[:user] )
    if @user.save
      sign_in @user
      redirect_to home_page_path
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

  protected

  def after_update_path_for(resource)
    user_path(resource)
  end

end
