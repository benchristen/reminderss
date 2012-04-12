class SessionsController < ApplicationController

  skip_before_filter :authorize, :except => :destroy

  layout "standard"

  def create
      open_id_authentication
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(new_session_url)
  end

  protected
    def open_id_authentication
      authenticate_with_open_id do |result, identity_url|
        if result.successful?
          if @current_user = User.find_by_identity_url(identity_url)
            successful_login
            #logger.debug "Success for (#{identity_url})"
          else
            successful_auth_new_user "Please create a new account for (#{identity_url})", identity_url
            #logger.debug "failed for (#{identity_url})"
          end
        else
          failed_login result.message
        end
      end
    end
  
  private
    def successful_login
      session[:user_id] = @current_user.id
      uri = session[:original_uri]
      session[:original_uri] = nil
      redirect_to(uri || "/events")
    end

    def successful_auth_new_user(message, identity_url)
      flash[:notice] = message
      session[:user_id] = identity_url
      redirect_to :controller => "users", :action => "new", :identity_url => identity_url
    end

    def failed_login(message)
      flash[:error] = message 
      redirect_to(new_session_url)
    end
end