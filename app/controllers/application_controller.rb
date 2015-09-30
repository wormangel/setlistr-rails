class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  protected
  def require_authorization
  	redirect_to :root unless current_user
  end
  
  protected
  def require_band_member(id)
    band = Band.find(id)
    redirect_to dashboard_path unless band.members.include?(current_user)
  end
  
  private
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  helper_method :current_user
end
