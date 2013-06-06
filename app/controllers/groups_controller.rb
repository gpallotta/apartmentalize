class GroupsController < ApplicationController

  before_filter :redirect_if_authenticated, only: [:new, :lookup, :create]
  before_filter :authenticate_user!, only: [:show]

  def show
  end

  def new
    if user_signed_in?
      redirect_to home_page_path
    else
      @group = Group.new
    end
  end

  def lookup
    @lookup = Group.find_by_identifier(params[:lookup][:identifier])
    if @lookup.nil?
      @group = Group.new
      @lookup_error = true
      render 'new'
    else
      set_current_group_before_login(@lookup)
      redirect_to new_user_registration_path
    end
  end

  def create
    @group = Group.new params[:group]
    if @group.save
      set_current_group_before_login(@group)
      redirect_to new_user_registration_path
    else
      render 'new'
    end
  end

end
