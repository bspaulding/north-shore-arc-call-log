class PeopleController < ApplicationController
  # Shows a Person's profile
  # Expected Params:
  # => TODO
  def show
    @person = Person.find(session[:user_id])
    # => TODO explain.
    if @person.class == DirectCareProvider && (session[:user_id].to_i != params[:id].to_i)
      flash[:notice] = "You can only access your own profile."
    else
      @person = Person.find(params[:id])
    end
  end
  
  # Search Page for People
  def search
    #if session[:search_id]
    #  @advanced_search = AdvancedSearch.find(session[:search_id])
    #else
    #  @advanced_search = AdvancedSearch.new
    #end
    @person = Person.new
  end
  
  def advanced_search
    if session[:advanced_search_id]
      @advanced_search = AdvancedSearch.find(session[:advanced_search_id])
    else
      @advanced_search = AdvancedSearch.new
    end
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