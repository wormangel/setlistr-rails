class UserController < ApplicationController
  before_filter :require_authorization
  
  def dashboard
    puts I18n.locale
    @contracts = Contract.where(user: current_user).includes(:band)
  end
  
  def show
    render 'show', layout: 'application'
  end
end
