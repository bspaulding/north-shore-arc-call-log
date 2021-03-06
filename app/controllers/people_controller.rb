# = PeopleController
#
# Author: Bradley J. Spaulding
#
# === Purpose
# This is the REST controller for the Person resource,
# handing all routes under /people.
class PeopleController < ApplicationController
	before_filter :authenticate, :authorize
	
	# Shows the printable call log
	def index
		@people = Person.find(:all, :order => 'last_name, first_name ASC')
		#render :file => 'people/index.html.erb'
		prawnto :prawn => {:page_layout => :landscape}
	end
	
  # Shows a Person's profile
  def show
  	@person = Person.find(params[:id])
  	@is_admin = false
  	active_person = Person.find(session[:user_id])
  	roles = active_person.roles.collect {|role| role.name}
    if roles == ["DirectCareProvider"] && session[:user_id] != params[:id]
      flash[:notice] = "You can only access your own profile."
      @person = active_person
    elsif roles.member?("Supervisor") || roles.member?("Administrator")
    	@is_admin = true
    end
  end
  
  # Receives an image for a Person.
  def upload_image
  	@person = Person.find(params[:id])
  	@person.image = params[:person][:image]
  	@person.save!
  	redirect_to @person
  end
  
  # Deletes a Person's image
  def remove_image
  	@person = Person.find(params[:id])
  	@person.image = nil
  	@person.save!
  	redirect_to @person
  end
end