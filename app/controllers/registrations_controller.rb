class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    @user = current_group.users.build( params[:user] )
    if @user.save
      sign_in @user
      redirect_to root_path
    else
      render 'new'
    end
  end

  def update
    super
  end

  protected

  def after_update_path_for(resource)
    user_path(resource)
  end

end
