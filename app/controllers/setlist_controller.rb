class SetlistController < ApplicationController
  before_filter :require_authorization
  
  def show
    @band = Band.find(params[:band_id])
    render 'show', layout: 'band'
  end
end
