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
  
  # Verify the user has logged in and redirect to login/index if not.
  def authenticate
  	unless session[:user_id]
  		session[:intended_controller] = controller_name
  		session[:intended_action] = action_name
	  	redirect_to :controller => 'login', :action => 'index'
	  end
  end
  
  # Check the current user's authorization for the desired action. Redirect to the user's home if not.
  def authorize
  	# Get all the current users' rights
  	person = Person.find(session[:user_id])
  	person.roles << Role.find(:first, :conditions => {:name => "DirectCareProvider"}) if person.roles.empty?
  	rights = person.roles.collect { |role| role.rights }.flatten
  	# Check each right against the current controller/action, and return true if an authorization path is found.
		rights.each do |right|
			if right.controller.blank?
		  	return true
		  elsif right.controller == controller_name && right.action.blank?
		  	return true
		  elsif right.controller == controller_name && right.action == action_name
		  	return true
		  end
		 end
 		 flash[:error] = "You are not authorized to view the page you have requested."
 		 redirect_to home_url(person)
  end
  
  # Return the Home URL for the current user. Either administrator/index, supervisor/index, or people/show/#{person.id}
	def home_url(person)
		if session[:home_url]
			return session[:home_url]
		else
			url = ""
			role_names = person.roles.collect { |role| role.name }
			if role_names.member?("Administrator")
				url = url_for(:controller => "administrator", :action => "index")
			elsif role_names.member?("Supervisor")
				url = url_for(:controller => "supervisor", :action => "index")
			else
				url = url_for(person)
			end
			session[:home_url] = url
			return url
		end
	end
end
