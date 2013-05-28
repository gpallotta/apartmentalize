class ClaimsController < ApplicationController

  def index
    @claim = Claim.new
  end

  def create
    current_user.group.users.each do |other|
      if params[other.name]
        @claim = Claim.new(params[:claim])
        @claim.user_who_owes = other
        @claim.user_owed_to = current_user
        if !@claim.save
          render 'index'
          return
        end
      end
    end
    redirect_to claims_path
  end

  def edit
    @claim = Claim.find(params[:id])
  end

  def update
    @claim = Claim.find(params[:id])
    if @claim.update_attributes(params[:claim])
      redirect_to claims_path
    else
      render 'edit'
    end
  end

  def destroy
    @claim = Claim.find(params[:id])
    @claim.destroy
    redirect_to claims_path
  end

end
