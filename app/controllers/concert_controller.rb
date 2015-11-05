class ConcertController < ApplicationController
  before_filter :require_authorization
  before_filter { require_band_member(params[:band_id]) }
  
  def index
    @band = Band.find(params[:band_id])

    render 'index', layout: 'band'
  end
  
  def new
    @band = Band.find(params[:band_id])
    @concert = Concert.new
    
    render 'new', layout: 'band'
  end
  
  def create
    @band = Band.find(params[:band_id])

    @concert = Concert.new(concert_params)
    if @concert.save
      flash[:notice] = "Concert created successfully!"
      redirect_to band_concert_path(@band.id, @concert.id)
    else
      render 'new', layout: 'band'
    end
  end
  
  def show
    @band = Band.find(params[:band_id])
    @concert = Concert.find(params[:id])
    
    render 'show', layout: 'band'
  end
  
  def edit
    @band = Band.find(params[:band_id])
    @concert = Concert.find(params[:id])
    
    render 'edit', layout: 'band'
  end
  
  def update
    @band = Band.find(params[:band_id])
    @concert = Concert.find(params[:id])
    
    if @concert.update(concert_params)
      flash[:notice] = "Concert updated successfully!"
      redirect_to band_concert_path(@band.id, @concert.id)
    else
      render 'edit', layout: 'band'
    end
  end
  
  def concert_params
    params[:concert][:band_id] = params[:band_id]
    params.require(:concert).permit(:name, :date, :time, :venue, :duration, :payment_type,
     :payment, :flyer, :description, :ticket_price, :band_id)
  end
end