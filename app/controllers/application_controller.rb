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
    redirect_to dashboard_path unless band.active_members.include?(current_user)
  end
  
  protected
  def require_admin
    puts current_user.admin
    redirect_to dashboard_path unless current_user.admin
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
    @profile_pic = 'https://graph.facebook.com/'+ uid + "/picture?type=" + size
  end
  
  def get_operating_system
    if request.env['HTTP_USER_AGENT'].downcase.match(/mac|iphone|os x/i)
      :osx
    elsif request.env['HTTP_USER_AGENT'].downcase.match(/windows/i)
      :osx
    elsif request.env['HTTP_USER_AGENT'].downcase.match(/linux|android/i)
      :linux
    elsif request.env['HTTP_USER_AGENT'].downcase.match(/unix/i)
      :unix
    else
      :unknown
    end
  end

  helper_method :profile_pic
  helper_method :current_user
end
