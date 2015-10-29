class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  protected
  def require_authorization
  	redirect_to (root_url + '?return=' + request.original_url) unless current_user
  end
  
  protected
  def require_band_member(id)
    band = Band.find(id)
    redirect_to dashboard_path unless band.members.include?(current_user)
  end
  
  private
  def current_user
    begin
      @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue Exception => e
      nil
    end
  end
  
  def profile_pic(size = 'square', uid = current_user.uid)
  @profile_pic = 'http://graph.facebook.com/'+ uid + "/picture?type=" + size
  end

  helper_method :profile_pic
  helper_method :current_user
end
