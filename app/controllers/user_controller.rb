class UserController < ApplicationController
  before_filter :require_authorization
  
  def dashboard
    @contracts = Contract.where(user: current_user).includes(:band)
  end
end
