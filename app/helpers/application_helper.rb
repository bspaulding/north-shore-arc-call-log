# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	# Return the Home URL for the current user
	def home_url
		person = Person.find(session[:user_id])
		url = ""
		role_names = person.roles.collect { |role| role.name }
		if role_names.member?("Administrator")
			url = url_for(:controller => "administrator", :action => "index")
		elsif role_names.member?("Supervisor")
			url = url_for(:controller => "supervisor", :action => "index")
		else
			url = url_for(person)
		end
		return url
	end
end
