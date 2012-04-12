# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  
  before_filter :authorize
  
  session :session_key => '_reminderss_session'
  
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :secret => '7266f70fc03735f1a56fe523cee52d0e'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

protected 
  def authorize 
    unless @current_user = User.find_by_id(session[:user_id]) 
      session[:original_uri] = request.request_uri
      flash[:notice] = "Please log in" 
      redirect_to :controller => :session, :action => :new 
    end 
  end 

  def authorize_admin
    unless User.find_by_id(session[:user_id]).admin?
      flash[:notice] = "Page unavailable - redirected to events index" 
      redirect_to :controller => :events, :action => :index 
    end 
  end 
  
  
end
