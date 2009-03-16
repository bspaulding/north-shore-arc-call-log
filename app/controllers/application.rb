# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery :only => [:create, :update, :destroy] # :secret => 'cdbb3ae46bde38280b369d19d5c10d9f'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  # Load parseexcel
  require 'parseexcel'
  
  # Verify the user, or force a login
  def authenticate
  	unless session[:user_id]
  		session[:intended_controller] = controller_name
  		session[:intended_action] = action_name
	  	redirect_to :controller => 'login', :action => 'index'
	  end
  end
  
  # Check the current user's authorization for their desired action
  def authorize
  	return true # STUB
  end
end
