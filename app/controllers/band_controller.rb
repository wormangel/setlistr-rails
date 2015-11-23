class BandController < ApplicationController
  before_filter :require_authorization
  before_filter(except: [:new, :create, :invite, :request_access]) { require_band_member(params[:id]) }
  
  def new
    @band = Band.new
    @band.contracts.build
    
    render 'new', layout: 'application'
  end
  
  def create
    @band = Band.new(band_params)
    @band.contracts.first.approved = true # Hackish
    if @band.save
      flash[:notice] = "Band created successfully!"
      redirect_to @band
    else
      render 'new', layout: 'application'
    end
  end
  
  def show
    @band = Band.find(params[:id])
  end
  
  def edit
    @band = Band.find(params[:id])
  end
  
  def update
    @band = Band.find(params[:id])
    
    if @band.update(band_update_params)
      flash[:notice] = "Band updated successfully!"
      redirect_to @band and return
    else
      render 'edit', layout: 'band'
    end
  end
  
  def invite
    @band = Band.from_invite_token(params[:invite_code])
     
    if @band.members.include?(current_user)
      flash[:alert] = "You're already a member of #{@band.name} or your invitation is still pending."
      redirect_to :dashboard and return
    end
    
    @contract = Contract.new
    
    render 'invite', layout: 'application'
  end
  
  def request_access
    @band = Band.find(params[:band_id])
    
    if @band.members.include?(current_user)
      flash[:alert] = "You're already a member of #{@band.name} or your invitation is still pending."
      redirect_to :dashboard and return
    end
    
    @contract = Contract.new(request_access_params)
    @contract.band = @band
    @contract.approved = false
    if @contract.save
      flash[:notice] = "Access requested! You'll have access once some bandmate approves you!"
    else
      flash[:alert] = "Something went wrong :("
    end
    
    redirect_to :dashboard
  end
  
  def grant_access
    @band = Band.find(params[:id])
    
    approve = params[:decision] == 'approve'
    contract = Contract.find(params[:contract_id])
    if approve
      contract.approved = true
      contract.save
      flash[:notice] = contract.user.first_name + ' is now part of the band!' 
    else
      contract.destroy
      flash[:notice] = contract.user.first_name + ' was rejected.' 
    end
    
    redirect_to @band
  end
  
  private
  def band_params
    #params.require(:band).permit(:name, :contract_attributes => [:instrument, :user_id])
    params[:band][:contract_attributes].each do |cont|
      cont.merge!({:user_id=>current_user.id})
    end
    params.require(:band).permit(:name, :contract_attributes => [:instrument, :user_id])
  end
  
  private
  def band_update_params
    params.require(:band).permit(:name, :genre, :release, :logo, :band_complete)
  end
  
  private
  def request_access_params
    params[:contract][:user_id] = current_user.id
    params.require(:contract).permit(:instrument, :user_id)
  end
end
