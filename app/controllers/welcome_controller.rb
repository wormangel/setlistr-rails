class WelcomeController < ApplicationController
  
  def index
    redirect_to :controller => 'user', :action => 'dashboard' if current_user
  end
end
