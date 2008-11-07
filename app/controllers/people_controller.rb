class PeopleController < ApplicationController
  # Shows a Person's profile
  def show
    @person = Person.find(session[:user_id])
    if @person.class == DirectCareProvider && (session[:user_id].to_i != params[:id].to_i)
      flash[:notice] = "You can only access your own profile."
    else
      @person = Person.find(params[:id])
    end
  end
  
  # Search Page for People
  def search
    @person = Person.new
  end
  
  def advanced_search
    @person = Person.new
  end
  
  def filter_results
    @people = []
    unless params[:person][:first_name] == "" && params[:person][:last_name] == ""
      if params[:person][:first_name].nil?
        @people = Person.find(:all, :conditions => ["last_name LIKE ?", "%#{params[:person][:last_name]}%"])
      elsif params[:person][:last_name].nil?
        @people = Person.find(:all, :conditions => ["first_name LIKE ?", "%#{params[:person][:first_name]}%"])
      else
        @people = Person.find(:all, :conditions => ["first_name LIKE ? AND last_name LIKE ?", "%#{params[:person][:first_name]}%", "%#{params[:person][:last_name]}%"])
      end
    end
  end
end