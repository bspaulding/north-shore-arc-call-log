class LoginController < ApplicationController
  def index
    
  end
  
  def login
    @person = Person.find(:first, :conditions => {:email_address => params[:email_address]})
    session[:user_id] = @person.id
    unless @person.nil?
      if @person.class == DirectCareProvider
        redirect_to person_url @person
      elsif @person.class == Supervisor
        redirect_to :controller => "supervisor"
      end
    end
  end
  
  def logout
  end
end
