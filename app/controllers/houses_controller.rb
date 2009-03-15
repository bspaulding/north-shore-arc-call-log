class HousesController < ApplicationController
	# In Place Editors
	# -> Allows in place editing for the specified fields
	in_place_edit_for :house, :agency_staff
	in_place_edit_for :house, :overview
	in_place_edit_for :house, :ratio
	in_place_edit_for :house, :trainings_needed
	in_place_edit_for :house, :medication_times
	in_place_edit_for :house, :waivers
	in_place_edit_for :house, :keys
	in_place_edit_for :house, :schedule_info
	in_place_edit_for :house, :behavior_plans
	in_place_edit_for :house, :phone_numbers
	in_place_edit_for :house, :address_street
	in_place_edit_for :house, :address_city
	in_place_edit_for :house, :address_state
	in_place_edit_for :house, :address_zip
	in_place_edit_for :house, :phone_1
	in_place_edit_for :house, :phone_2
	in_place_edit_for :house, :fax
	
  # auto_complete_for :person, 'first_name'
  # custom auto_complete_for method is required, since 'name' is a virtual attribute
  def auto_complete_for_person_name
  	name = params[:person][:name].downcase
  	names = name.strip.split(' ')
  	
    find_options = {
      :order => "last_name, first_name ASC",
	  :limit => 10 }

		if names.size > 1
			# there are two names provided
			find_options[:conditions] = "LOWER(first_name) LIKE '%#{names[0]}%' AND LOWER(last_name) LIKE '%#{names[1]}%' OR LOWER(first_name) LIKE '%#{names[1]}%' AND LOWER(last_name) LIKE '%#{names[0]}%'"
		else
			# only the first name or last name has been provided
			find_options[:conditions] = "LOWER(first_name) LIKE '%#{names[0]}%' OR LOWER(last_name) LIKE '%#{names[0]}%'"
		end
	
		@items = Person.find(:all, find_options)
	
		Rails.logger.info("@items.size = #{@items.size}")

    render :inline => "<%= auto_complete_result @items, 'name' %>"
  end

	# Method: add_person_to_house
	# Ajax Method, adds the specified person to the house, and pushes the updated view to the browser.
  def add_person_to_house
  	begin
	  @house = House.find(params[:house_id])
  	  name = params[:person][:name]
  	  names = name.strip.split(' ')
   	  @person = Person.find(:first, :conditions => {:first_name => names[0], :last_name => names[1]})
   	  @house.people << @person
   	  render :update do |page|
   	  	page.replace_html 'house_detail', :partial => 'house', :object => @house
   	  	page.visual_effect :highlight, "house_person_id_#{@person.id}"
   	  end
  	rescue ActiveRecord::RecordNotFound
  	  #flash[:error] = "We're sorry, there was a problem with your request. Please try again."
  	end
  end

	# Method: remove_person
	# Removes the person with id = params[:person_id] from the house with id = params[:house_id]
	# Ajax method, returns updated view to the browser.
	def remove_person
		@house = House.find(params[:house_id])
		@person = Person.find(params[:person_id])
		@house.people.delete(@person)
		
		render :update do |page|
			#page.replace_html 'house_detail', :partial => 'house', :object => @house
			page.visual_effect :fade, "house_person_id_#{@person.id}", :duration => 0.25
		end
	end
	
  def index
    @houses = House.all
  end

  def show
  	begin
	  @house = House.find(params[:id])
	rescue ActiveRecord::RecordNotFound
	  flash[:error] = "I'm sorry, we couldn't locate that house. Please try again."
	  redirect_to :action => 'index'
	end
  end
end
