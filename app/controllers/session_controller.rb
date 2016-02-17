class SessionController < ApplicationController

  def create
    if not current_user # new login
      user = User.from_omniauth(env["omniauth.auth"])
      session[:user_id] = user.id
    else # user is already logged in and adds a new login provider
      current_user.add_omniauth_provider(env["omniauth.auth"])
    end
    redirect_to request.params['return'] || :dashboard
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
  
  def auth_failure
    flash[:alert] = "Auth error. Server replied: \"" + params[:message] + "\""
    redirect_to root_url
  end
end
