class BandController < ApplicationController
  before_filter :require_authorization
  
  def new
  end
end
