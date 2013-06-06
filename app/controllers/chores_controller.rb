class ChoresController < ApplicationController

  before_filter :authenticate_user!

  def index
    @chores = current_user.group.chores.all
    @chore = Chore.new
  end

  def create
    @chore = Chore.new(params[:chore])
    @chore.group = current_user.group
    if @chore.save
      redirect_to chores_path
    else
      @chores = current_user.group.chores.all
      render 'index'
    end
  end

  def edit
    @chore = Chore.find_by_id(params[:id])
  end

  def update
    @chore = Chore.find_by_id(params[:id])
    if @chore.update_attributes(params[:chore])
      redirect_to chores_path
    else
      render 'edit'
    end
  end

  def destroy
    @chore = Chore.find(params[:id])
    @chore.destroy
    redirect_to chores_path
  end

end
