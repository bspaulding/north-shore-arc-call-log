class PeopleController < ApplicationController
	before_filter :authenticate, :authorize
	
  # Shows a Person's profile
  # Expected Params:
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
  
  def upload_image
  	@person = Person.find(params[:id])
  	@person.image = params[:person][:image]
  	@person.save!
  	redirect_to @person
  end
  
  def advanced_search_results
    @search = AdvancedSearch.find(session[:advanced_search_id])
    @people = @search.people
  end
  
  def filter_results
    @people = []
    unless params[:person][:first_name] == "" && params[:person][:last_name] == ""
      if params[:person][:first_name].nil?
        conditions = ["last_name LIKE ?", "%#{params[:person][:last_name]}%"]
      elsif params[:person][:last_name].nil?
        conditions = ["first_name LIKE ?", "%#{params[:person][:first_name]}%"]
      else
        conditions = ["first_name LIKE ? AND last_name LIKE ?", 
                          "%#{params[:person][:first_name]}%", 
                          "%#{params[:person][:last_name]}%"]
      end
    end
    unless conditions.nil?
      @people = Person.find(:all, :conditions => conditions)
    end
    render :action => 'filter_results', :layout => false
  end
end