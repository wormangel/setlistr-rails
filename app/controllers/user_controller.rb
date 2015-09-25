class UserController < ApplicationController
  before_filter :require_authorization
  
  def dashboard
  end
end
