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
end