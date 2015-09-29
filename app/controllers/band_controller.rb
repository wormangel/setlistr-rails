class BandController < ApplicationController
  before_filter :require_authorization
  
  def new
    @band = Band.new
    @band.contracts.build
    
    @instrument_list = Contract::INSTRUMENTS
  end
  
  def create
  end
end
