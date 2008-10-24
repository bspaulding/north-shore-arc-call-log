class HomeController < ApplicationController
  auto_complete_for :person, :first_name
  
  def index
    @people = Person.all
  end
  
  def people_search
    @people = Person.find(:all, :conditions => ["first_name = ?", params[:person][:first_name]])
  end
end