class LoginController < ApplicationController
  def index
  end
  
  def login
    @person = Person.find(:first, :conditions => {:email_address => params[:email_address]})
    if @person.nil?
    	flash[:error] = "Invalid Email Address. Please Try Again."
    	redirect_to :controller => 'login', :action => 'index'
    else
    	# This is a normal user, authenticate and set session[:user_id] = @person.id
    	begin
	      session[:user_id] = Person.authenticate(params[:email_address], params[:password]).id
				redirect_to home_url(@person)
			rescue CallLogExceptions::InvalidUser
				flash[:error] = "Invalid Username or Password"
				redirect_to :controller => 'login', :action => 'index'
			end
    end
  end
  
  def register
  end
  
  def new_user_setup
  	@person = Person.find(:first, :conditions => {:email_address => params[:email_address]})
  	if @person.nil?
  		flash[:error] = "Invalid Email Address."
  		redirect_to :action => 'register'
		elsif !@person.password_hash.blank?
  		flash[:error] = "Your account has already been set up. See the system administrator for help logging in."
  		redirect_to :action => 'index'
  	elsif params[:password] != params[:password_confirm]
  		flash[:error] = "Passwords don't match. Please try again."
  		redirect_to :action => 'register'
  	else
  		@person.password = params[:password]
  		@person.save!
  		redirect_to home_url(@person)
  	end
  end
  
  def logout
  	session[:user_id] = nil
  	flash[:notice] = "You have successfully logged out."
  	redirect_to :action => 'index'
  end
end
