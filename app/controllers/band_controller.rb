class BandController < ApplicationController
  before_filter :require_authorization
  before_filter(except: [:new, :create]) { require_band_member(params[:id]) }
  
  def new
    @band = Band.new
    @band.contracts.build
    
    render 'new', layout: 'application'
  end
  
  def create
    @band = Band.new(band_params)
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
  
  def invite
    puts params[:emails].split(', ')
    redirect_to :action => 'show'
  end
  
  private
  def band_params
    #params.require(:band).permit(:name, :contract_attributes => [:instrument, :user_id])
    params[:band][:contract_attributes].each do |cont|
      cont.merge!({:user_id=>current_user.id})
    end
    params.require(:band).permit(:name, :contract_attributes => [:instrument, :user_id])
  end
end
