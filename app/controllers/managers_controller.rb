class ManagersController < ApplicationController

  def new
    @manager = Manager.new
  end

  def create
    @manager = current_user.group.managers.new(params[:manager])
    if @manager.save
      redirect_to user_path(current_user)
    else
      render 'new'
    end
  end

  def edit
    @manager = Manager.find_by_id(params[:id])
  end

  def update
    @manager = Manager.find_by_id(params[:id])
    if @manager.update_attributes(params[:manager])
      redirect_to user_path(current_user)
    else
      render 'edit'
    end
  end

  def destroy
    @manager = Manager.find_by_id(params[:id])
    @manager.destroy
    redirect_to user_path(current_user)
  end

end
