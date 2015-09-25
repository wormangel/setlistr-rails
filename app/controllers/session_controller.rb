class SessionController < ApplicationController
  def create
    user = User.from_omniauth(env["omniauth.auth"])
    session[:user_id] = user.id
    redirect_to :controller => 'user', :action => 'dashboard'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
  
  def auth_failure
    flash[:alert] = "Ocorreu um erro de autenticação. O Facebook respondeu: \"" + params[:message] + "\""
    redirect_to root_url
  end
end
